local function get_node_cmd()
  -- Prefer your pinned nvm node, but fall back to whatever is on $PATH.
  local pinned = vim.fn.expand '$HOME' .. '/.nvm/versions/node/v22.22.0/bin/node'
  if vim.fn.executable(pinned) == 1 then
    return pinned
  end

  local on_path = vim.fn.exepath 'node'
  if on_path ~= '' and vim.fn.executable(on_path) == 1 then
    return on_path
  end

  return nil
end

local function copilot_enabled()
  return get_node_cmd() ~= nil
end

return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  enabled = copilot_enabled,
  event = 'InsertEnter',
  build = ':Copilot auth',
  init = function()
    if copilot_enabled() then
      return
    end

    vim.schedule(function()
      local pinned = vim.fn.expand '$HOME' .. '/.nvm/versions/node/v22.22.0/bin/node'
      vim.api.nvim_echo({
        {
          ('[copilot] disabled: node executable not found (tried %s and $PATH)'):format(pinned),
          'WarningMsg',
        },
      }, true, {})
    end)
  end,
  opts = function()
    local opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
      },
      panel = { enabled = false },
      filetypes = {
        sh = function()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
            return false -- disable for .env files
          end
          return true
        end,
      },
    }

    local node_cmd = get_node_cmd()
    if node_cmd then
      opts.copilot_node_command = node_cmd
    end

    return opts
  end,
  keys = {
    {
      '<leader>cs',
      function()
        require('copilot.panel').open { position = 'right', ratio = 0.2 }
      end,
      desc = '[C]opilot [S]uggest',
    },
    {
      '<C-CR>',
      mode = 'i',
      function()
        require('copilot.suggestion').accept()
      end,
      desc = '[C]opilot [S]uggest',
    },
    {
      '<C-j>',
      mode = 'i',
      function()
        require('copilot.suggestion').prev()
      end,
      desc = '[C]opilot [S]uggest',
    },
    {
      '<C-k>',
      mode = 'i',
      function()
        require('copilot.suggestion').next()
      end,
      desc = '[C]opilot [S]uggest',
    },
  },
}
