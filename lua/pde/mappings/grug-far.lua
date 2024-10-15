return {
  { cond = "grug-far.nvim" },

  find_replace_sg = {
    function() require("grug-far").open { engine = "astgrep" } end,
    desc = "Find and replace with astgrep",
  },
  find_replace_rg = {
    function() require("grug-far").open { engine = "ripgrep" } end,
    desc = "Find and replace with ripgrep",
  },
}
