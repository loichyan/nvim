---@type LazyPluginSpec
return {
  "andymass/vim-matchup",
  event = "User AstroFile",
  specs = {
    { "nvim-treesitter", opts = { matchup = { enable = true } } },
  },
  config = function(_, opts)
    local ok, cmp = pcall(require, "cmp")
    if ok then
      cmp.event:on("menu_opened", function() vim.b.matchup_matchparen_enabled = false end)
      cmp.event:on("menu_closed", function() vim.b.matchup_matchparen_enabled = true end)
    end
    require("match-up").setup(opts)
  end,
}
