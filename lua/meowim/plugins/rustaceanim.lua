---@type MeoSpec
local Spec = { "mrcjkb/rustaceanvim", event = "LazyFile" }

Spec.config = function()
  local rust_analyzer = require("meowim.config.lspconfig").rust_analyzer
  vim.g.rustaceanvim = {
    server = vim.tbl_extend("force", rust_analyzer, { auto_attach = rust_analyzer.enable }),
  }
end

return Spec
