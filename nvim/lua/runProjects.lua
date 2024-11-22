vim.system({ 'ls' }, {}, function(out)
  vim.print('terminate', vim.inspect(out))
end)
