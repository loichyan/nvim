---@diagnostic disable:missing-fields
---@type LazyPluginSpec
return {
  "mrcjkb/rustaceanvim",

  cond = not vim.g.vscode,
  ft = "rust",

  config = function()
    vim.g.rustaceanvim = { server = require("astrolsp").lsp_opts "rust_analyzer" or {} }
  end,
}
