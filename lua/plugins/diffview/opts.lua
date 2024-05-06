local actions = require "diffview.actions"
local close = { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } }
return {
  keymaps = {
    file_panel = {
      close,
      { "n", "<c-u>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
      { "n", "<c-d>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
    },
    file_history_panel = {
      close,
    },
  },
}
