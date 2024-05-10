---@type LazySpec
return {
  -- Rust
  {
    "mrcjkb/rustaceanvim",
    cond = not vim.g.vscode,
    event = "User AstroFile",
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
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
      }
    end,
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
