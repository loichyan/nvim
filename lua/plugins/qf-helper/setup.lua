return function(_, opts)
  require("qf_helper").setup(opts)
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("qf_helper_user_autocmds", { clear = true }),
    pattern = "qf",
    callback = function(args)
      vim.keymap.set("n", "o", "<CR><C-W>p", { buffer = args.buf, noremap = true })
    end,
  })
end
