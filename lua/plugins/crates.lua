---@type LazySpec
return {
  "Saecki/crates.nvim",
  cond = vim.g.vscode,
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    popup = { border = "rounded" },
    null_ls = { enabled = true },
  },
}
