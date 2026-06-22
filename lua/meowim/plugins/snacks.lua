---@type MeoSpec
local Spec = {
  'folke/snacks.nvim',
  lazy = false,
  priority = 90,
}

Spec.config = function()
  require('snacks').setup({
    quickfile = { enabled = true },
    words = { enabled = true, debounce = 300 },
    scratch = {
      enabled = true,
      ft = 'markdown',
      filekey = { branch = false },
    },
  })
end

return Spec
