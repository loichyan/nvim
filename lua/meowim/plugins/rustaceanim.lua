---@type MeoSpec
return {
    "mrcjkb/rustaceanvim",
    event = "LazyFile",
    config = function()
        local rust_analyzer = require("meowim.lspconfig").rust_analyzer
        vim.g.rustaceanvim = {
            server = vim.tbl_extend("force", rust_analyzer, { auto_attach = rust_analyzer.enable }),
        }
    end,
}
