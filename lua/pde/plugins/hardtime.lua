---@type LazyPluginSpec
return {
  "m4xshen/hardtime.nvim",
  event = "User AstroFile",
  dependencies = { "nui.nvim", "plenary.nvim" },
  opts = {
    disabled_filetypes = {
      "lazy",
      "mason",
      "neo-tree",
      "netrw",
      "oil",
      "qf",
    },
  },
}
