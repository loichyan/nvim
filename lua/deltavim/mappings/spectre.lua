return {
  { cond = "nvim-spectre" },

  find_replace = {
    function() require("spectre").open { is_insert_mode = true } end,
    desc = "Find and replace",
  },
  find_replace_current = {
    function() require("spectre").open_file_search { is_insert_mode = true } end,
    desc = "Find and replace current file",
  },
}
