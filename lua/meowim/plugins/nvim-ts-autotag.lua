---@type MeoSpec
return {
  "windwp/nvim-ts-autotag",
  event = "LazyFile",
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-ts-autotag").setup({
      per_filetype = { ["rust"] = { enable_close = false } },
    })
  end,
  dependencies = { "nvim-treesitter" },
}
