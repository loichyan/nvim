local config = function()
    ---@module "lspconfig"
    ---@type lspconfig.Config
    ---@diagnostic disable-next-line:missing-fields
    local servers = {
        basedpyright = {},
        bashls = {},
        clangd = { cmd = { "clangd", "--offset-encoding=utf-16" } },
        cssls = {},
        denols = {},
        eslint = {},
        gopls = {},
        hls = {},
        jsonls = {
            settings = { json = { validate = { enable = true } } },
            on_attach = function(client)
                client.notify("workspace/didChangeConfiguration", {
                    settings = {
                        json = { schemas = require("schemastore").json.schemas() },
                    },
                })
            end,
        },
        lua_ls = {
            settings = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    completion = { callSnippet = "Replace" },
                },
            },
        },
        nil_ls = {},
        ruff = {},
        taplo = {},
        tailwindcss = {},
        texlab = {},
        ts_ls = {
            root_dir = function(...) require("lspconfig.util").root_pattern("package.json")(...) end,
            single_file_support = false,
        },
        typos_lsp = {},
        yamlls = {
            settings = { yaml = { validate = true, keyOrdering = false } },
            on_attach = function(client)
                client.notify("workspace/didChangeConfiguration", {
                    settings = {
                        yaml = { schemas = require("schemastore").yaml.schemas() },
                    },
                })
            end,
        },
    }

    for name, config in pairs(servers) do
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
    end
end

---@type MeoSpec
return { "neovim/nvim-lspconfig", event = "LazyFile", config = config }
