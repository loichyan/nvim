---@type LazySpec
return {
  "andymass/vim-matchup",
  event = "User AstroFile",
  dependencies = {
    {
      "nvim-treesitter",
      opts = {
        matchup = { enable = true },
      },
    },
  },
}
