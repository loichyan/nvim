---@type LazyPluginSpec
return {
  "subnut/nvim-ghost.nvim",
  cond = not vim.g.vscode,
  lazy = false,
  config = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "*.*",
      group = "nvim_ghost_user_autocommands",
      callback = function()
        local opt = vim.opt_local
        opt.filetype = "markdown"
        opt.textwidth = 0
        opt.wrap = true
      end,
    })
  end,
}
