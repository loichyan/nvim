local peek_toggle = function()
  local peek = require "peek"
  if peek.is_open() then
    peek.close()
  else
    peek.open()
  end
end

return function()
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
end
