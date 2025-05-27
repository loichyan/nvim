---@type MeoSpec
return {
    "mrcjkb/rustaceanvim",
    event = "LazyFile",
    config = function()
        local rust_analyzer = require("meowim.lspconfig").rust_analyzer
        rust_analyzer.auto_attach = rust_analyzer.enable
        vim.g.rustaceanvim = { server = rust_analyzer }
    end,
}
