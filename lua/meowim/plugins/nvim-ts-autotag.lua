---@type MeoSpec
local Spec = {
  "windwp/nvim-ts-autotag",
  event = "LazyFile",
  dependencies = { "nvim-treesitter" },
}

Spec.config = function()
  ---@diagnostic disable-next-line: missing-fields
  require("nvim-ts-autotag").setup({
    per_filetype = { ["rust"] = { enable_close = false } },
  })
end

return Spec
