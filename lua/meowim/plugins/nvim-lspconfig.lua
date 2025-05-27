---@type MeoSpec
return {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    config = function()
        for name, config in pairs(require("meowim.lspconfig").servers()) do
            vim.lsp.config(name, config)
            if name ~= "rust_analyzer" and config.enable ~= false then
                vim.lsp.enable(name)
            end
        end
    end,
}
