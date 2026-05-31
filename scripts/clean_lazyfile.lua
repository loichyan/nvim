-- Collect plugins not registered in meow.nvim.
local active_plugins = {}
require('meowim.bootstrap') -- load all registered plugins
for _, plugin in ipairs(Meow.plugins()) do
  active_plugins[plugin.name] = true
end
local inactive_plugins = {}
for _, plugin in ipairs(vim.pack.get()) do
  if not active_plugins[plugin.spec.name] then table.insert(inactive_plugins, plugin.spec.name) end
end

local lockfile_path = vim.fn.stdpath('config') .. '/nvim-pack-lock.json'
local lockfile_str = io.open(lockfile_path):read('*a')
local lockfile = vim.json.decode(lockfile_str)
for _, name in ipairs(inactive_plugins) do
  lockfile.plugins[name] = nil
end
lockfile_str = vim.json.encode(lockfile, { indent = '  ', sort_keys = true })
io.open(lockfile_path, 'w'):write(lockfile_str, '\n')
