---@type MeoSpec
return {
  "folke/neoconf.nvim",
  event = "LazyFile",
  config = function() require("neoconf").setup({ plugins = { lspconfig = { enabled = false } } }) end,
}
