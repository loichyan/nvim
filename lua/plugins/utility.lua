return {
  {
    "smart-splits.nvim",
    cond = not vim.g.vscode,
    -- build = "./kitty/install-kittens.bash",
    opts = { multiplexer_integration = false },
  },

  {
    "nacro90/numb.nvim",
    event = "User AstroFile",
    opts = {},
  },

  {
    "wakatime/vim-wakatime",
    cond = not vim.g.vscode,
    event = "VeryLazy",
  },

  {
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
  },

  {
    "Vigemus/iron.nvim",
    cond = not vim.g.vscode,
    cmd = { "IronAttach", "IronRepl" },
    opts = function() return require "plugins.iron.opts" end,
    config = function(_, opts) require("iron.core").setup(opts) end,
  },

  {
    "stevearc/qf_helper.nvim",
    cmd = { "QFOpen", "QFToggle", "LLOpen", "LLToggle" },
    ft = { "qf" },
    opts = {
      quickfix = { default_bindings = false },
      loclist = { default_bindings = false },
    },
    config = function(...) return require "plugins.qf-helper.setup"(...) end,
  },
}
