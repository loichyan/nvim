---@type MeoSpec
local Spec = { "neovim/nvim-lspconfig", event = "VeryLazy" }

Spec.config = function()
  for name, config in pairs(require("meowim.config.lspconfig")) do
    vim.lsp.config(name, config)
    if name ~= "rust_analyzer" and config.enable ~= false then vim.lsp.enable(name) end
  end
end

return Spec
