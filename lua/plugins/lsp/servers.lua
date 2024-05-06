---@type lspconfig.options
---@diagnostic disable:missing-fields
return {
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
        format = {
          enable = false,
        },
      },
    },
  },
  nil_ls = {},
  pyright = {},
  rust_analyzer = {
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
    on_attach = function(_, bufnr)
      local map = vim.keymap.set
      map(
        "n",
        "<Leader>le",
        "<Cmd>RustLsp expandMacro<CR>",
        { desc = "Expand macro", buffer = bufnr }
      )
      map(
        "n",
        "<Leader>lc",
        "<Cmd>RustLsp openCargo<CR>",
        { desc = "Open Cargo.toml", buffer = bufnr }
      )
    end,
  },
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
