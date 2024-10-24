---@type LazyPluginSpec
return {
  "sindrets/diffview.nvim",
  cond = not vim.g.vscode,
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  opts = function()
    local actions = require "diffview.actions"
    local close = { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } }
    return {
      keymaps = {
        file_panel = {
          close,
          { "n", "<C-U>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
          { "n", "<C-D>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
        },
        file_history_panel = { close },
        view = { close },
      },
    }
  end,
}
