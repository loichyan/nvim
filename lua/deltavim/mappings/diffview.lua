return {
  { cond = "diffview.nvim" },

  open = {
    function() require("diffview").open {} end,
    desc = "Open diffview",
  },
  open_last_commit = {
    function() require("diffview").open { "HEAD~1" } end,
    desc = "Open diffview with last commit",
  },
  open_file_history = {
    function() require("diffview").file_history(nil, {}) end,
    desc = "Open current file history",
  },
}
