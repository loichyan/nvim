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
        cue_fmt = {},
        fish_indent = {},
        nixfmt = {},
        prettierd = {},
        shfmt = {},
        stylua = {},
      },
      linters = {
        cue_fmt = {},
        fish = {},
        hadolint = {},
      },
    },
  },
}
