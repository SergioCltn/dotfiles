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

vim.api.nvim_create_user_command('AutoRun', function()
  local command = vim.split(vim.fn.input 'Command: ', ' ')
  local pattern = vim.fn.input 'Pattern: '

  if #command == 0 or #pattern == 0 then
    print 'Command and pattern cannot be empty.'
    return
  end

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.cmd 'vsplit'
  vim.api.nvim_win_set_buf(0, bufnr)

  attach_to_buffer(bufnr, pattern, command)
end, { desc = 'Open the output buffer for auto run program' })
