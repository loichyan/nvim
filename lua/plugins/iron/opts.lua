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
