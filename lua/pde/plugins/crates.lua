---@type LazyPluginSpec
return {
  "Saecki/crates.nvim",
  cond = not vim.g.vscode,
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    popup = { border = "rounded" },
    null_ls = { enabled = true },
  },
}
