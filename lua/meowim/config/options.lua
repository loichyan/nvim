-- Options that must be set before loading plugins.

local g, o = vim.g, vim.o

g.mapleader = " "
g.localleader = "\\"

o.clipboard = "unnamed"
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4

o.cmdheight = 0 -- Hide cmdline
o.showcmdloc = "statusline" -- Display command messages in statusline
o.laststatus = 3 -- Show global statusline
o.conceallevel = 2 -- Improve rendering for Markdown
o.relativenumber = true -- Show relative numbers

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
    cache_enabled = 1,
  }
  o.clipboard = "unnamed" -- Use tmux's clipboard if possible
else
  g.clipboard = false -- Otherwise disable the clipboard
end
