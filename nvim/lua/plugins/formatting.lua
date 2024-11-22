return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        -- Fallback represent that if the formatter fails it will use the lsp
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      --
      local disable_filetypes = { c = true, cpp = true, javascript = true, typescriptreact = true }
      local lsp_format_opt
      if disable_filetypes[vim.bo[bufnr].filetype] then
        lsp_format_opt = 'never'
      else
        lsp_format_opt = 'fallback'
      end
      return {
        timeout_ms = 500,
        lsp_format = lsp_format_opt,
      }
    end,
    formatters_by_ft = {
      clang = { 'clangd' },
      javascript = {},
      typescript = {},
      javascriptreact = {},
      typescriptreact = {},
      css = { 'prettierd' },
      html = { 'prettierd' },
      json = { 'prettierd' },
      yaml = { 'prettierd' },
      markdown = { 'prettierd' },
      graphql = { 'prettierd' },
      lua = { 'stylua' },
      python = { 'isort', 'black' },
    },
  },
}
