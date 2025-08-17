-- Options that must be set before loading plugins.

local g, o = vim.g, vim.o

g.mapleader = " "
g.localleader = "\\"

o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4

o.cmdheight = 0 -- Hide cmdline
o.showcmdloc = "statusline" -- Display command messages in statusline
o.laststatus = 3 -- Show global statusline
o.conceallevel = 2 -- Improve rendering for Markdown
o.relativenumber = true -- Show relative numbers

o.jumpoptions = "stack" -- More intuitive jumps

if vim.fn.has("nvim-0.12") == 1 then require("vim._extui").enable({ enable = true }) end

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
  o.clipboard = "unnamed"
else
  g.clipboard = "osc52" -- Otherwise fallback to OSC52
  o.clipboard = ""
end
