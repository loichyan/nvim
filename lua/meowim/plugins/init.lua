---@type MeoSpecs
return {
  { "loichyan/meow.nvim", lazy = false, priority = math.huge },
  { "echasnovski/mini.nvim", lazy = false, priority = math.huge },
  { import = "meowim.plugins.mini" },
  { "meowim", shadow = true, config = function() require("meowim").setup() end },
}
