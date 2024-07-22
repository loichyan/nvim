_ = {
  "kylechui/nvim-surround",
  keys = {
    { "yz", desc = "Add surrounding", mode = "n" },
    { "dz", desc = "Delete surrounding", mode = "n" },
    { "cz", desc = "Change surrounding", mode = "n" },
  },
  opts = {
    keymaps = {
      normal = "yz",
      normal_cur = "yzz",
      visual = "z",
      delete = "dz",
      change = "cz",
      insert = false,
      insert_line = false,
      visual_line = false,
      change_line = false,
      normal_line = false,
      normal_cur_line = false,
    },
    aliases = {
      ["?"] = "i",
    },
  },
}

---@type LazyPluginSpec
return {
  "echasnovski/mini.surround",
  keys = {
    { "yz", desc = "Add surrounding", mode = "n" },
    { "yzz", desc = "Add surrounding around current line", mode = "n" },
    { "z", desc = "Add surrounding", mode = "x" },
    { "dz", desc = "Delete surrounding", mode = "n" },
    { "cz", desc = "Change surrounding", mode = "n" },
  },
  opts = {
    mappings = {
      add = "yz",
      delete = "dz",
      replace = "cz",
      find = "",
      find_left = "",
      highlight = "",
      update_n_lines = "",
    },
    n_lines = 500,
    search_method = "cover",
  },
}
