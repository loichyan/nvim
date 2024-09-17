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
    n_lines = 200,
    search_method = "cover_or_next",
  },
}
