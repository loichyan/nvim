---@type LazyPluginSpec
return {
  "stevearc/qf_helper.nvim",

  cond = not vim.g.vscode,
  ft = "qf",
  cmd = {
    "QFOpen",
    "QFToggle",
    "LLOpen",
    "LLToggle",
    "QFNext",
    "QFPrev",
  },

  opts = {
    quickfix = { default_bindings = false },
    loclist = { default_bindings = false },
  },
  config = function(_, opts)
    require("qf_helper").setup(opts)
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("qf_helper_user_autocmds", { clear = true }),
      pattern = "qf",
      callback = function(args)
        vim.keymap.set("n", "o", "<C-W>p", { buffer = args.buf, noremap = true })
      end,
    })
  end,
}
