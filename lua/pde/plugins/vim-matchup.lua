---@type LazyPluginSpec
return {
  "andymass/vim-matchup",
  event = "User AstroFile",
  dependencies = {
    { "nvim-treesitter", opts = { matchup = { enable = true } } },
  },
  opts = function() vim.g.matchup_matchparen_pumvisible = 0 end,
}
