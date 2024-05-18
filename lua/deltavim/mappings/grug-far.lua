return {
  { cond = "grug-far.nvim" },

  find_replace = {
    function() require("grug-far").grug_far {} end,
    desc = "Find and replace",
  },
  find_replace_current = {
    function()
      require("grug-far").grug_far {
        prefills = {
          -- credit: https://stackoverflow.com/a/24463362/22726229
          filesFilter = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":."),
        },
      }
    end,
    desc = "Find and replace current file",
  },
}
