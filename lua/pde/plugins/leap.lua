---@type LazyPluginSpec
return {
  "ggandor/leap.nvim",
  enabled = false,
  dependencies = { { "tpope/vim-repeat", lazy = true } },
  keys = function()
    return {
      { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from window" },
    }
  end,
  opts = {
    equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" },
    special_keys = { prev_target = "<backspace>", prev_group = "<backspace>" },
  },
  config = function(_, opts)
    require("deltavim.utils").deep_merge(require("leap").opts, opts)
    require("leap.user").set_repeat_keys("<enter>", "<backspace>")

    local map = vim.keymap.set
    map({ "n", "x", "o" }, "s", "<Plug>(leap-forward-to)")
    map({ "n", "x", "o" }, "S", "<Plug>(leap-backward-to)")
    map({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
  end,
}
