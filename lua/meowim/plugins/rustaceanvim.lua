---@type MeoSpec
local Spec = { 'mrcjkb/rustaceanvim', event = 'LazyFile' }

Spec.config = function()
  Meow.load('nvim-lspconfig')
  local lspconfig = vim.lsp.config['rust_analyzer'] --[[@cast lspconfig -nil]]
  vim.g.rustaceanvim = {
    server = {
      auto_attach = true,
      capabilities = lspconfig.capabilities,
      on_attach = lspconfig.on_attach,
      default_settings = lspconfig.settings,
    },
  }
end

return Spec
