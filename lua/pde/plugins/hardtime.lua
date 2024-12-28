---@type LazyPluginSpec
return {
  "m4xshen/hardtime.nvim",
  event = "User AstroFile",
  dependencies = { "nui.nvim", "plenary.nvim" },
  opts = {
    restricted_keys = {
      -- we need these keys to jump among quickfix items
      ["<C-N>"] = {},
      ["<C-P>"] = {},
    },
    disabled_filetypes = {
      "grug-far",
      "lazy",
      "mason",
      "netrw",
      "neo-tree",
      "NvimTree",
      "oil",
      "qf",
    },
  },
}
