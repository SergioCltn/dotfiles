local bufnr

local attach_to_buffer = function(output_bufnr, pattern, command)
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup('AutoReloadGo', { clear = true }),
    pattern = pattern,
    callback = function()
      local append_data = function(_, data)
        if data then
          vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
        end
      end

      vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, { table.concat(command, ' '), '' })

      vim.fn.jobstart(command, {
        stdout_buffered = true,
        on_stdout = append_data,
        on_stderr = append_data,
        on_exit = function(_, code)
          if code ~= 0 then
            vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, { 'Error: Command failed with code ' .. code })
          end
        end,
      })
    end,
  })
end

local function create_window_split(output_bufnr)
  vim.cmd.vnew() -- Create a new vertical split
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_buf(0, output_bufnr)
  vim.api.nvim_win_set_height(0, 10)
  -- vim.api.nvim_win_set_width(0, 50)

  local last_line = vim.api.nvim_buf_line_count(output_bufnr)
  vim.api.nvim_win_set_cursor(0, { last_line, 0 }) -- Move cursor to the last line
  vim.wo.scrolloff = 0 -- Disable scrolloff to ensure the last line is at the bottom
  vim.wo.cursorline = false -- Optional: Disable cursorline to avoid visual distraction

  vim.opt.number = false
  vim.opt.relativenumber = false
  vim.opt.signcolumn = 'no'

  vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
    buffer = output_bufnr,
    callback = function()
      local line_count = vim.api.nvim_buf_line_count(output_bufnr)
      vim.api.nvim_win_set_cursor(0, { line_count, 0 }) -- Move cursor to the last line
    end,
  })
end

vim.api.nvim_create_user_command('AutoRun', function()
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
    create_window_split(bufnr)
    return
  end

  local command = vim.split(vim.fn.input 'Command: ', ' ')
  local pattern = vim.fn.input 'Pattern: '

  if #command == 0 or #pattern == 0 then
    print 'Command and pattern cannot be empty.'
    return
  end

  bufnr = vim.api.nvim_create_buf(false, true)
  create_window_split(bufnr)

  attach_to_buffer(bufnr, pattern, command)
end, { desc = 'Open the output buffer for auto run program' })
