local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local make_entry = require 'telescope.make_entry'
local conf = require('telescope.config').values

local M = {}

--- Converts a filter string into glob patterns for ripgrep
--- Examples:
---   "lua" -> "**/*lua*" and "**/*lua*/**"
---   "src" -> "**/src/**" and "**/*src*"
---   "*.ts" -> "*.ts" (unchanged if already a glob)
---   "!node_modules" -> "!**/node_modules/**" (exclusion)
---@param filter string
---@return string[]
local function parse_filter(filter)
  local globs = {}
  filter = vim.trim(filter)

  if filter == '' then
    return globs
  end

  -- Split by comma or space for multiple filters
  local filters = vim.split(filter, '[,; ]+')

  for _, f in ipairs(filters) do
    f = vim.trim(f)
    if f ~= '' then
      local is_exclusion = f:sub(1, 1) == '!'
      local pattern = is_exclusion and f:sub(2) or f
      local prefix = is_exclusion and '!' or ''

      -- Check if it's already a glob pattern
      local is_glob = pattern:match '[%*%?%[%]]'

      if is_glob then
        -- Already a glob, use as-is but ensure it has **/ prefix for flexibility
        if not pattern:match '^%*%*' and not pattern:match '^/' then
          table.insert(globs, prefix .. '**/' .. pattern)
        else
          table.insert(globs, prefix .. pattern)
        end
      else
        -- Not a glob - make it fuzzy
        -- Match files/folders containing the pattern anywhere in path
        table.insert(globs, prefix .. '**/*' .. pattern .. '*')
        table.insert(globs, prefix .. '**/*' .. pattern .. '*/**')
      end
    end
  end

  return globs
end

local live_multigrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local finder = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == '' then
        return nil
      end

      -- Split on double space: "search term  filter"
      local pieces = vim.split(prompt, '  ')
      local search_term = pieces[1]
      local filter = pieces[2]

      if not search_term or search_term == '' then
        return nil
      end

      local args = { 'rg', '-e', search_term }

      -- Add glob patterns for filtering
      if filter and filter ~= '' then
        local globs = parse_filter(filter)
        for _, glob in ipairs(globs) do
          table.insert(args, '-g')
          table.insert(args, glob)
        end
      end

      ---@diagnostic disable-next-line: deprecated
      return vim.tbl_flatten {
        args,
        {
          '--hidden',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '-g',
          '!.git/',
        },
      }
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = 'Multi Grep (search  filter)',
      finder = finder,
      previewer = conf.grep_previewer(opts),
      sorter = require('telescope.sorters').empty(),
    })
    :find()
end

M.setup = function()
  vim.keymap.set('n', '<leader>sg', live_multigrep, { desc = '[S]earch by [G]rep (use "  " for filter)' })
end

return M
