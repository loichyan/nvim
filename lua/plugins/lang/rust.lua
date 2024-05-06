---@type LazySpec
return {
  -- Rust
  {
    "mrcjkb/rustaceanvim",
    cond = not vim.g.vscode,
    event = "User AstroFile",
    ft = { "rust" },
    init = function() vim.g.rustaceanvim = require("plugins.lsp.servers").rust_analyzer end,
  },

  {
    "Saecki/crates.nvim",
    cond = vim.g.vscode,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      popup = { border = "rounded" },
      null_ls = { enabled = true },
    },
  },
}
