return {
  { cond = "quicker.nvim" },

  toggle_quickfix = {
    function() require("quicker").toggle() end,
    desc = "Toggle quickfix panel",
  },
  toggle_loclist = {
    function() require("quicker").toggle { loclist = true } end,
    desc = "Toggle loclist panel",
  },
}
