return {
  { cond = "qf_helper.nvim" },

  toggle_quickfix = {
    "<Cmd>QFToggle!<CR>",
    desc = "Toggle quickfix panel",
  },
  toggle_loclist = {
    "<Cmd>LFToggle!<CR>",
    desc = "Toggle loclist panel",
  },

  next_quickfix = {
    "<Cmd>QFNext<CR>",
    desc = "Next quickfix item",
  },
  prev_quickfix = {
    "<Cmd>QFPrev<CR>",
    desc = "Previous quickfix item",
  },
}
