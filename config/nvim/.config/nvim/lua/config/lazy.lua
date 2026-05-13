-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local result = vim.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }, { text = true }):wait()
  if result.code ~= 0 then
    error('Error cloning lazy.nvim:\n' .. result.stderr)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)
