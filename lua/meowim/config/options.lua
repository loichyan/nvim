-- Options that must be set before loading plugins.

local g, o, opt = vim.g, vim.o, vim.opt

g.mapleader = ' '
g.localleader = '\\'

o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4

o.colorcolumn = '+1' -- show ruler
o.cmdheight = 0 -- hide cmdline
o.showcmdloc = 'statusline' -- display command messages in statusline
o.laststatus = 3 -- show global statusline
o.showtabline = 2 -- always show tabline
o.conceallevel = 2 -- improve rendering for Markdown
o.relativenumber = true -- show relative numbers
o.jumpoptions = 'stack' -- more intuitive jumps

opt.diffopt:append('algorithm:histogram', 'inline:word') -- improve diff mode
opt.listchars = { nbsp = '⎵', tab = '› ' } -- better listchars
opt.shortmess:append('A') -- suppress swapfile warnings

-- Enable mode shapes, "Cursor" highlight, and blinking, see `:h 'guicursor'`.
o.guicursor = 'n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50'
  .. ',a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor'
  .. ',sm:block-blinkwait175-blinkoff150-blinkon175'

o.foldexpr = 'v:lua.Meowim.utils.foldexpr()'
o.foldmethod = 'expr'
o.foldlevel = 99

if vim.fn.has('nvim-0.12') == 1 then
  opt.fillchars:append({
    fold = ' ',
    foldclose = '',
    foldinner = ' ',
    foldopen = '',
    foldsep = ' ',
  })
  o.statuscolumn = '%s%l%C '
  o.foldcolumn = '1'
end

if vim.env['TMUX'] then -- use tmux's buffers if possible
  g.clipboard = {
    name = 'tmux',
    copy = { ['+'] = { 'tmuxcpy', '-w' }, ['*'] = { 'tmuxcpy' } },
    paste = { ['+'] = { 'tmuxpst' }, ['*'] = { 'tmuxpst' } },
    cache_enabled = 1,
  }
  o.clipboard = 'unnamed'
else -- otherwise, fallback to OSC52
  g.clipboard = 'osc52'
  o.clipboard = ''
end
