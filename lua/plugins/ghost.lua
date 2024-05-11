return {
  "subnut/nvim-ghost.nvim",
  lazy = false,
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
