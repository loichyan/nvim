---@type LazyPluginSpec
return {
  "subnut/nvim-ghost.nvim",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  config = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "*.*",
      group = "nvim_ghost_user_autocommands",
      callback = function()
        vim.bo.filetype = "markdown"
        vim.bo.textwidth = 0
      end,
    })
  end,
}
