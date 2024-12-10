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
  dev = { path = "~/dev/projects" },
  spec = {
    {
      "loichyan/DeltaVim",
      dev = true,
      ---@type DeltaOptions
      opts = {
        mapleader = " ",
        maplocalleader = "\\",
        icons_enabled = true,
        pin_plugins = vim.env.DELTA_PIN_PLUGINS == "1",
      },
    },
    { import = "deltavim.plugins" },
    { import = "deltavim.presets.mappings" },
    { import = "pde.plugins" },
    { import = "pde.vscode_fixup" },
  },
  defaults = { lazy = true, version = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "bugreport",
        "ftplugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "health",
        "logipat",
        "matchit",
        "matchparen",
        "netrw",
        "netrwFileHandlers",
        "netrwPlugin",
        "netrwSettings",
        "nvim",
        "optwin",
        "rplugin",
        "rrhelper",
        "spellfile",
        "spellfile_plugin",
        "synmenu",
        "syntax",
        "tar",
        "tarPlugin",
        "tohtml",
        "tutor",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
      },
    },
  },

  install = {
    missing = not vim.g.vscode,
    colorscheme = { "catppuccin", "habamax" },
  },
  -- https://github.com/folke/lazy.nvim/issues/1008
  change_detection = { enabled = false },
  readme = { enabled = false },
  pkg = { enabled = false },
} --[[@as LazyConfig]]
