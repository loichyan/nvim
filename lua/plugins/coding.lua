---@type LazySpec
return {
  {
    "nvim-cmp",
    opts = function(_, opts) table.insert(opts.sources, { name = "crates" }) end,
  },

  {
    "junegunn/vim-easy-align",
    cmd = { "EasyAlign" },
  },

  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = function() return require "plugins.surround.opts" end,
  },

  {
    "ggandor/leap.nvim",
    event = "User AstroFile",
    dependencies = {
      { "tpope/vim-repeat", lazy = true },
    },
    opts = {
      equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" },
      special_keys = { prev_target = "<backspace>", prev_group = "<backspace>" },
    },
    config = function(...) require "plugins.leap.setup"(...) end,
  },
}
