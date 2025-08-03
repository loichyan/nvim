---@module "lspconfig"
---@type lspconfig.Config|table<string,vim.lsp.Config|{enable:boolean}>
---@diagnostic disable-next-line:missing-fields
local Lspconfig = {
  -- Common
  taplo = {},
  jsonls = {
    settings = { json = { validate = { enable = true } } },
    on_init = function(client)
      client:notify("workspace/didChangeConfiguration", {
        settings = {
          json = { schemas = require("schemastore").json.schemas() },
        },
      })
    end,
  },
  yamlls = {
    settings = { yaml = { validate = true, keyOrdering = false } },
    on_init = function(client)
      client:notify("workspace/didChangeConfiguration", {
        settings = {
          yaml = { schemas = require("schemastore").yaml.schemas() },
        },
      })
    end,
  },
  typos_lsp = {},

  -- Scripting
  bashls = {},

  -- Python
  basedpyright = {},
  ruff = {},

  -- C/C++
  clangd = { cmd = { "clangd", "--offset-encoding=utf-16" } },

  -- Web
  cssls = {},
  tailwindcss = { enable = false },
  eslint = { enable = false },
  denols = {},
  ts_ls = {
    root_dir = function(...) require("lspconfig.util").root_pattern("package.json")(...) end,
    single_file_support = false,
  },

  -- Golang
  gopls = {},

  -- Lua
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        completion = { callSnippet = "Replace" },
      },
    },
  },

  -- Nix
  nil_ls = {},

  -- Rust
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cachePriming = { enable = false },
        check = { command = "clippy" },
        procMacro = { enable = true, attributes = { enable = true } },
        typing = { autoClosingAngleBrackets = { enable = true } },
        imports = {
          granularity = { enforce = true, group = "module" },
          prefix = "self",
        },
        buildScripts = { rebuildOnSave = true },
      },
    },
    on_attach = function(_, bufnr)
      Meow.keyset(bufnr, {
        { "<Leader>lm", "<Cmd>RustLsp expandMacro<CR>", desc = "Expand macro" },
        { "<Leader>lo", "<Cmd>RustLsp openCargo<CR>", desc = "Open Cargo.toml" },
      })
    end,
  },
}

-- Load workspace configurations
for name, config in pairs((require("neoconf").get("lspconfig") or {})) do
  if type(config) == "boolean" then config = { enable = config } end
  Lspconfig[name] = vim.tbl_deep_extend("force", Lspconfig[name] or {}, config)
end

return Lspconfig
