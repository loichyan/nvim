---@type LazyPluginSpec
return {
  "astrolsp",
  ---@param opts AstroLSPOpts
  opts = function(_, opts)
    ---@type lspconfig.options
    ---@diagnostic disable:missing-fields
    local config = {
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

    -- rust-analyzer is set up by rustaceanvim
    local servers = vim.tbl_keys(config)
    config.rust_analyzer = {
      settings = {
        ["rust-analyzer"] = {
          check = { command = "clippy" },
          rustfmt = { overrideCommand = { "rustfmt-nightly" } },
          procMacro = { enable = true, attributes = { enable = true } },
          typing = { autoClosingAngleBrackets = { enable = true } },
          imports = { granularity = { enforce = true } },
          buildScripts = { rebuildOnSave = true },
        },
      },
    }

    require("deltavim.utils").merge(opts, { config = config, servers = servers })
  end,
}
