---@type MeoSpec
local Spec = { "folke/flash.nvim", event = "LazyFile" }

Spec.config = function()
  ---@diagnostic disable:missing-fields
  require("flash").setup({
    search = { multi_window = false },
    highlight = { backdrop = false },
    modes = {
      char = {
        enabled = true,
        autohide = true,
        jump_labels = true,
        multi_line = false,
        jump = { autojump = true },
        search = { wrap = false },
        highlight = { backdrop = false },
      },
      search = {
        enabled = true,
        search = { wrap = false },
        highlight = { backdrop = false },
      },
      treesitter = {
        highlight = { backdrop = false },
      },
    },
    prompt = { enabled = false },
  })

  Meow.keymap({
    {
      "s",
      function() require("flash").jump({ search = { forward = true, wrap = false } }) end,
      mode = { "n", "o", "x" },
      desc = "Flash forward",
    },
    {
      "S",
      function() require("flash").jump({ search = { forward = false, wrap = false } }) end,
      mode = { "n", "o", "x" },
      desc = "Flash backward",
    },
    {
      "O",
      function() require("flash").treesitter() end,
      mode = { "o", "x" },
      desc = "Flash treesitter",
    },
    {
      "<C-s>",
      function() require("flash").toggle() end,
      mode = { "c" },
      desc = "Toggle Flash search",
    },
  })
end

return Spec
