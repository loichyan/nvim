-- Bootstrap begin
local start_time = vim.uv.hrtime()

if not vim.fn.has('nvim-0.12') then error('Meowim requires Neovim >= 0.12') end

-- Enable the experimental loader for faster `require`s.
vim.loader.enable(true)

-- Enable profiler for debug/benchmark
if vim.env['MEO_ENABLE_PROFILE'] then
  vim.cmd.packadd('snacks.nvim')
  require('snacks.profiler').startup({ startup = { event = 'UIEnter' } })
end

-- Disable some useless standard plugins to speed up the startup.
local disabled_builtins = {
  'gzip',
  -- 'matchit',
  -- 'matchparen',
  'netrwPlugin',
  'tarPlugin',
  'tohtml',
  'tutor',
  'zipPlugin',
}
for _, p in ipairs(disabled_builtins) do
  vim.g['loaded_' .. p] = true
end

-- Install the plugin manager and then load our plugin specs.
vim.pack.add({ 'https://github.com/loichyan/meow.nvim' }, { confirm = false })
-- Configure the preferred colorscheme
vim.g.colors_name = 'base16-gruvbox-material'
require('meow').setup({
  specs = { import = 'meowim.plugins' },
  -- Enable import caching to reduce I/O loads.
  import_cache = function() return require('meowim.cache_token') end,
})

-- Bootstrap end
vim.g.meowim_startup_time = vim.uv.hrtime() - start_time
