---@type LazyPluginSpec
return {
  "astrolsp",
  ---@param opts AstroLSPOpts
  opts = function(_, opts)
    ---@type lspconfig.options
    ---@diagnostic disable:missing-fields
    local config = {
      basedpyright = {},
      bashls = {},
      clangd = {
        -- c.f. https://github.com/Alexis12119/nvim-config/blob/9efdf7bc943f/lua/plugins/lsp/settings/clangd.lua
        cmd = { "clangd", "--offset-encoding=utf-16" },
      },
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
            completion = { callSnippet = "Replace" },
          },
        },
      },
      nil_ls = {
        settings = {
          ["nil"] = { nix = { flake = { autoArchive = true } } },
        },
      },
      ruff_lsp = {},
      taplo = {},
      tailwindcss = {},
      texlab = {},
      ts_ls = {
        root_dir = function(...) require("lspconfig.util").root_pattern "package.json"(...) end,
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

    -- rust-analyzer is set up by rustaceanvim
    local servers = vim.tbl_keys(config)
    config.rust_analyzer = {
      settings = {
        ["rust-analyzer"] = {
          check = { command = "clippy" },
          rustfmt = { overrideCommand = { "rustfmt-nightly" } },
          procMacro = { enable = true, attributes = { enable = true } },
          typing = { autoClosingAngleBrackets = { enable = true } },
          imports = { granularity = { enforce = true, group = "module" }, prefix = "self" },
          buildScripts = { rebuildOnSave = true },
        },
      },
    }

    require("deltavim.utils").merge(opts, { config = config, servers = servers })
  end,
}
