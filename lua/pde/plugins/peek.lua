---@type LazyPluginSpec
return {
  "toppair/peek.nvim",
  build = "deno task --quiet build:fast",

  cond = not vim.g.vscode,
  ft = "markdown",
  cmd = "Peek",

  opts = { app = "browser" },
  config = function(_, opts)
    require("peek").setup(opts)

    local peek_toggle = function()
      local peek = require "peek"
      if peek.is_open() then
        peek.close()
      else
        peek.open()
      end
    end

    vim.api.nvim_create_user_command("Peek", peek_toggle, {})
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("peek_user_autocmds", {}),
      pattern = "markdown",
      callback = function(args)
        vim.keymap.set("n", "<Leader>lp", peek_toggle, {
          desc = "Toggle markdown preview",
          buffer = args.buf,
        })
      end,
    })
  end,
}
