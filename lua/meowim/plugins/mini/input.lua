---@type MeoSpec
local Spec = {
  'mini.input',
  event = 'VeryLazy',
}

Spec.config = function()
  local miniinput = require('mini.input')

  local remap = {
    ['<C-a>'] = '<C-b>',
    ['<C-e>'] = '<C-e>',
    ['<C-b>'] = '<Left>',
    ['<C-f>'] = '<Right>',
    ['<A-b>'] = '<S-Left>',
    ['<A-f>'] = '<S-Right>',
  }
  local remap_codes = {}
  for l, r in pairs(remap) do
    remap_codes[vim.keycode(l)] = vim.keycode(r)
  end
  local key_handler = function(state, key) miniinput.default_key(state, remap_codes[key] or key) end

  miniinput.setup({ handlers = { key = key_handler } })
end

return Spec
