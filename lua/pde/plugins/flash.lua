---@type LazyPluginSpec
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      char = {
        autohide = true,
        jump_labels = true,
        multi_line = false,
        jump = { autojump = true },
      },
      search = {
        enabled = true,
        highlight = { backdrop = true },
        search = { wrap = false },
      },
      treesitter = {
        highlight = { backdrop = true },
        label = { style = "overlay" },
      },
    },
    prompt = { enabled = false },
  },
  keys = {
    {
      "s",
      mode = { "n", "o", "x" },
      function() require("flash").jump { search = { forward = true, wrap = false } } end,
      desc = "Flash forward",
    },
    {
      "S",
      mode = { "n", "o", "x" },
      function() require("flash").jump { search = { forward = false, wrap = false } } end,
      desc = "Flash backward",
    },
    {
      "gs",
      mode = { "n", "o", "x" },
      function() require("flash").remote() end,
      desc = "Remote Flash",
    },
    {
      "O",
      mode = { "o", "x" },
      function() require("flash").treesitter() end,
      desc = "Flash treesitter",
    },
    {
      "<C-S>",
      mode = { "c" },
      function() require("flash").toggle() end,
      desc = "Toggle Flash search",
    },
  },
}
