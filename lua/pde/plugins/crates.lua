---@type LazyPluginSpec
return {
  "Saecki/crates.nvim",
  cond = not vim.g.vscode,
  ft = "toml",
  opts = function() return { popup = { border = require("deltavim").get_border "popup_border" } } end,
}
