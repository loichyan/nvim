---@type LazyPluginSpec
return {
  "astrolsp",
  ---@param opts AstroLSPOpts
  opts = function(_, opts)
    ---@type lspconfig.options
    ---@diagnostic disable:missing-fields
    local servers = {
      bashls = {},
      clangd = {},
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
            workspace = {
              checkThirdParty = false,
              library = { "${3rd}/luv/library" },
            },
          },
        },
      },
      nil_ls = {},
      pyright = {},
      taplo = {},
      tailwindcss = {},
      texlab = {},
      tsserver = {},
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

    require("deltavim.utils").merge(opts, {
      config = servers,
      servers = vim.tbl_keys(servers),
      linters = {
        fish = {},
        hadolint = {},
      },
    })
  end,
}
