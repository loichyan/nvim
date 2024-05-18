---@type LazyPluginSpec
return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  opts = {
    keymaps = {
      -- normal and insert mode
      replace = { n = "<Enter>", i = "<C-Enter>" },
      qflist = "<C-X>",
      syncLocations = "<C-S>",
      syncLine = "<C-L>",
      close = { n = "q", i = "<C-C>" },
      -- normal mode only
      gotoLocation = { n = "o" },
    },
  },
}
