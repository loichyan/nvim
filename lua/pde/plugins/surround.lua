---@type LazyPluginSpec
return {
  "kylechui/nvim-surround",
  keys = {
    { "yz", desc = "Add surrounding", mode = "n" },
    { "yzz", desc = "Add surrounding around current line", mode = "n" },
    { "z", desc = "Add surrounding", mode = "x" },
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
      insert = "<Nop>",
      insert_line = "<Nop>",
      visual_line = "<Nop>",
      change_line = "<Nop>",
      normal_line = "<Nop>",
      normal_cur_line = "<Nop>",
    },
    aliases = {
      ["?"] = "i",
    },
  },
}
