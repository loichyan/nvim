-- disable some plugins when running as the backend of VSCode.
if not vim.g.vscode then return {} end

local plugins = {
  -- disable some treesitter modules
  { "nvim-treesitter", opts = { highlight = { enable = false } } },
  -- astroui is required by astrocore and a few other plugins (for icons),
  -- we only disable colorscheme
  { "astroui", opts = function(_, opts) opts.colorscheme = nil end },
}

-- TODO: fix old plugins
local disabled = {
  "aerial.nvim",
  "alpha-nvim",
  "astrolsp",
  "astrotheme",
  "better-escape.nvim",
  "catppuccin",
  "cmp-buffer",
  "cmp-nvim-lsp",
  "cmp-path",
  "cmp_luasnip",
  "dressing.nvim",
  "friendly-snippets",
  "heirline.nvim",
  "indent-blankline.nvim",
  "LuaSnip",
  "mini.bufremove",
  "neo-tree.nvim",
  "neoconf.nvim",
  "neodev.nvim",
  "none-ls.nvim",
  "nui.nvim",
  "nvim-autopairs",
  "nvim-cmp",
  "nvim-colorizer.lua",
  "nvim-lspconfig",
  "nvim-notify",
  "nvim-ufo",
  "nvim-web-devicons",
  "nvim-window-picker",
  "resession.nvim",
  "smart-splits.nvim",
  "telescope-fzf-native.nvim",
  "telescope.nvim",
  "todo-comments.nvim",
  "vim-illuminate",
  "which-key.nvim",
}

for _, name in ipairs(disabled) do
  table.insert(plugins, { name, cond = false })
end

return plugins
