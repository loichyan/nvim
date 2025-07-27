-- Options that must be set before loading plugins.

local g, o = vim.g, vim.o

g.mapleader = " "
g.localleader = "\\"

o.relativenumber = true -- Show relative numbers
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4
o.conceallevel = 2

if vim.env.TMUX then
  g.clipboard = {
    name = "tmux",
    copy = {
      ["+"] = { "tmux", "-Ldefault", "load-buffer", "-w", "-" }, -- Copy to system clipboard
      ["*"] = { "tmux", "-Ldefault", "load-buffer", "-" }, -- Copy to only tmux clipboard
    },
    paste = {
      ["+"] = { "tmux", "-Ldefault", "save-buffer", "-" },
      ["*"] = { "tmux", "-Ldefault", "save-buffer", "-" },
    },
    cache_enabled = 0,
  }
  o.clipboard = "unnamed" -- Use tmux's clipboard by default
else
  g.clipboard = false -- Otherwise disable the clipboard
end
