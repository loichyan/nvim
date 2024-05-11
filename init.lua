-- bootstrap lazy.nvim
local lazyroot = vim.fn.stdpath "data" .. "/lazy"
local lazypath = lazyroot .. "/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
---@diagnostic disable-next-line:undefined-field
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  vim.api.nvim_echo({
    { "Unable to load lazy from: %s" .. lazypath, "ErrorMsg" },
    { "\nPress any key to exit...", "MoreMsg" },
  }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

require("lazy").setup {
  root = lazyroot,
  dev = { path = "~/dev/nvim" },
  spec = {
    {
      "loichyan/DeltaVim",
      dev = true,
      ---@type DeltaOptions
      opts = {
        mapleader = " ",
        maplocalleader = "\\",
        icons_enabled = true,
      },
    },
    { import = "deltavim.plugins" },
    { import = "deltavim.presets.mappings" },
    { import = "pde.plugins" },
    { import = "pde.vscode_fixup" },
  },
  defaults = { lazy = true, version = false },
  install = {
    missing = not vim.g.vscode,
    colorscheme = { "catppuccin", "habamax" },
  },
  checker = { enabled = false },
  change_detection = { enabled = true },
  ui = { backdrop = 100 },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
} --[[@as LazyConfig]]
