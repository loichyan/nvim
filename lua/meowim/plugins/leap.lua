---@type MeoSpec
local Spec = {
  'ggandor/leap.nvim',
  source = 'https://codeberg.org/andyg/leap.nvim',
  event = 'LazyFile',
  dependencies = { 'vim-repeat' },
}

Spec.config = function()
  local leap = require('leap')
  -- Keep current 'conceallevel'
  leap.opts.vim_opts['wo.conceallevel'] = nil

  local treesitter_opts = { opts = require('leap.user').with_traversal_keys('O', 'o') }
  local nox, ox = { 'n', 'o', 'x' }, { 'o', 'x' }

  -- stylua: ignore
  Meow.keymap({
    { 's', function() require('leap').leap({inclusive_op=true}) end,                      desc = 'Leap forward'    },
    { 's', function() require('leap').leap({inclusive_op=true,offset=1}) end, mode = ox,  desc = 'Leap forward'    },
    { 'S', function() require('leap').leap({backward=true}) end,              mode = nox, desc = 'Leap backward'   },
    { 'O', function() require('leap.treesitter').select(treesitter_opts) end, mode = ox,  desc = 'Leap treesitter' },
  })
end

return Spec
