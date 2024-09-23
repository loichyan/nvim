---@module "quicker"

---@type LazyPluginSpec
return {
  "stevearc/quicker.nvim",
  event = "FileType qf",
  ---@type quicker.SetupOptions
  opts = {},
}
