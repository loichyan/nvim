---@type LazyPluginSpec
return {
  "nvim-lint",
  opts = {
    linters_by_ft = {
      dockerfile = { "hadolint" },
      fish = { "fish" },
    },
  },
}
