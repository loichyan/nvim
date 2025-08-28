---@type MeoSpec
local Spec = { "folke/neoconf.nvim", event = "LazyFile" }

Spec.config = function()
  require("neoconf").setup({
    plugins = { lspconfig = { enabled = false } },
  })
end

return Spec
