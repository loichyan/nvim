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
