return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  enabled = true,
  event = 'InsertEnter',
  build = ':Copilot auth',
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
    },
    panel = { enabled = false },
    copilot_node_command = vim.fn.expand '$HOME' .. '/.nvm/versions/node/v22.11.0/bin/node',
    filetypes = {
      sh = function()
        if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
          return false -- disable for .env files
        end
        return true
      end,
    },
  },
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
