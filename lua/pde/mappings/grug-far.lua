return {
  { cond = "grug-far.nvim" },

  find_replace_current = {
    function() require("grug-far").open { engine = "astgrep" } end,
    desc = "Find and replace current file",
  },
  find_replace_workspace = {
    function()
      require("grug-far").open {
        engine = "astgrep",
        prefills = {
          -- credit: https://stackoverflow.com/a/24463362/22726229
          filesFilter = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":."),
        },
      }
    end,
    desc = "Find and replace in workspace",
  },
}
