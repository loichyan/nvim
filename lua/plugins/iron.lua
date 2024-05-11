return {
  "Vigemus/iron.nvim",
  cond = not vim.g.vscode,
  cmd = { "IronAttach", "IronRepl" },
  opts = function()
    return {
      config = {
        scratch_repl = true,
        repl_definition = {
          python = {
            command = { "ipython" },
            format = require("iron.fts.common").bracketed_paste,
          },
        },
        repl_open_cmd = require("iron.view").split.vertical(0.4, {
          winfixwidth = false,
          winfixheight = false,
        }),
      },
      keymaps = {},
    }
  end,
  config = function(_, opts) require("iron.core").setup(opts) end,
}
