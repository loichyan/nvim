---@type MeoSpec
return {
    "mrcjkb/rustaceanvim",
    event = "LazyFile",
    config = function()
        local rust_analyzer = {
            on_attach = function(_, bufnr)
                Meow.keyset(bufnr, {
                    { "<Leader>lm", "<Cmd>RustLsp expandMacro<CR>", desc = "Expand macro" },
                    { "<Leader>lo", "<Cmd>RustLsp openCargo<CR>", desc = "Open Cargo.toml" },
                })
            end,
            settings = {
                ["rust-analyzer"] = {
                    cachePriming = { enable = false },
                    check = { command = "clippy" },
                    rustfmt = { overrideCommand = { "rustfmt-nightly" } },
                    procMacro = { enable = true, attributes = { enable = true } },
                    typing = { autoClosingAngleBrackets = { enable = true } },
                    imports = {
                        granularity = { enforce = true, group = "module" },
                        prefix = "self",
                    },
                    buildScripts = { rebuildOnSave = true },
                },
            },
        }
        vim.g.rustaceanvim = { server = rust_analyzer }
    end,
}
