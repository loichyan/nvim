---@type MeoSpec
return {
  "loichyan/meoline.nvim",
  shadow = true,
  event = "UIEnter",
  config = function() require("meoline").setup() end,
}
