---@type LazyPluginSpec
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      search = { enabled = true, highlight = { backdrop = true } },
      treesitter = { highlight = { backdrop = true } },
    },
    prompt = { enabled = false },
  },
  keys = {
    {
      "s",
      mode = { "n", "o", "x" },
      function() require("flash").jump() end,
      desc = "Flash",
    },
    {
      "S",
      mode = { "n", "o", "x" },
      function() require("flash").treesitter() end,
      desc = "Flash treesitter",
    },
    {
      "gs",
      mode = { "n", "o", "x" },
      function() require("flash").remote() end,
      desc = "Remote Flash",
    },
    {
      "<C-S>",
      mode = { "c" },
      function() require("flash").toggle() end,
      desc = "Toggle Flash search",
    },
  },
}
