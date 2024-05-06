---@type LazySpec
return {
  {
    "nvim-treesitter",
    dependencies = {
      { "IndianBoy42/tree-sitter-just", lazy = true, opts = {} },
      { "andymass/vim-matchup", lazy = true },
    },
    opts = {
      matchup = { enable = true },
    },
  },
}
