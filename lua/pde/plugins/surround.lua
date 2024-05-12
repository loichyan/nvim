---@type LazyPluginSpec
return {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  opts = {
    keymaps = {
      insert = "<C-G>z",
      insert_line = "<C-G>Z",
      normal = "yz",
      normal_cur = "yzz",
      normal_line = "yZ",
      normal_cur_line = "yZZ",
      visual = "Z",
      visual_line = "gZ",
      delete = "dz",
      change = "cz",
      change_line = "cZ",
    },
    aliases = {
      ["?"] = "i",
    },
  },
}
