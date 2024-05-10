local servers = require "plugins.lsp.servers"

---@type LazySpec
return {
  {
    "astrolsp",
    opts = {
      config = servers,
      servers = vim.tbl_keys(servers),
      formatters = {
        black = {},
        fish_indent = {},
        nixfmt = {},
        prettierd = {},
        shfmt = {},
        stylua = {},
      },
      linters = {
        fish = {},
        hadolint = {},
      },
    },
  },
}
