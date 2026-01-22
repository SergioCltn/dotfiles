local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local make_entry = require 'telescope.make_entry'
local conf = require('telescope.config').values
local fzy = require 'telescope.algos.fzy'
local utils = require 'telescope.utils'

local M = {}

---@param cwd string
---@return string[]
local function list_files(cwd)
  -- Prefer fd for speed/ignores; fall back to rg --files.
  if vim.fn.executable 'fd' == 1 then
    return utils.get_os_command_output({ 'fd', '--type', 'f', '--hidden', '--follow', '--exclude', '.git' }, cwd)
  end

  return utils.get_os_command_output({ 'rg', '--files', '--hidden', '--glob', '!.git/*' }, cwd)
end

---@param files string[]
---@param query string
---@param limit integer
---@return string[]|nil
local function fuzzy_filter_files(files, query, limit)
  query = vim.trim(query or '')
  if query == '' then
    return nil
  end

  local scored = {}
  local score_min = fzy.get_score_min()

  for _, path in ipairs(files) do
    if fzy.has_match(query, path) then
      local score = fzy.score(query, path)
      if score and score > score_min then
        scored[#scored + 1] = { score = score, path = path }
      end
    end
  end

  -- If the file query matches nothing, restrict to /dev/null to produce no results
  -- without surfacing ripgrep errors.
  if #scored == 0 then
    return { '/dev/null' }
  end

  table.sort(scored, function(a, b)
    return a.score > b.score
  end)

  local out = {}
  local n = math.min(limit, #scored)
  for i = 1, n do
    out[i] = scored[i].path
  end

  return out
end

local live_multigrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()
  opts.file_filter_limit = opts.file_filter_limit or 200

  -- Cache file list for the duration of this picker.
  local all_files = list_files(opts.cwd)

  local finder = finders.new_job(function(prompt)
    if not prompt or prompt == '' then
      return nil
    end

    -- Split on *two* spaces:
    --   "search"            => grep everywhere
    --   "search  filequery" => grep only in fuzzily-matched files
    local search, file_query = prompt:match '^(.-)%s%s+(.*)$'
    if not search then
      search = prompt
    end

    search = vim.trim(search)
    if search == '' then
      return nil
    end

    local args = vim.deepcopy(conf.vimgrep_arguments)

    -- Search term uses ripgrep regex + smart-case (from `conf.vimgrep_arguments`).
    vim.list_extend(args, { '--hidden', '--glob', '!.git/*', '-e', search })

    if file_query and vim.trim(file_query) ~= '' then
      local files = fuzzy_filter_files(all_files, file_query, opts.file_filter_limit)

      -- rg supports restricting search to a list of files after `--`.
      -- If the fuzzy query matches nothing, we pass a dummy file to produce no results.
      if files then
        table.insert(args, '--')
        vim.list_extend(args, files)
      end
    end

    return args
  end, make_entry.gen_from_vimgrep(opts), opts.max_results, opts.cwd)

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = 'Multi Grep (search␠␠file)',
      finder = finder,
      previewer = conf.grep_previewer(opts),
      sorter = require('telescope.sorters').empty(),
    })
    :find()
end

M.setup = function()
  vim.keymap.set('n', '<leader>sg', live_multigrep, { desc = '[S]earch by [G]rep (use "  " for file filter)' })
end

return M
