-- disable some plugins when running as the backend of VSCode.
if not vim.g.vscode then return {} end

local plugins = {
  -- coding
  { "nvim-cmp" },
  { "LuaSnip" },
  { "nvim-autopairs" },
  { "mini.comment" },
  -- editor
  { "nvim-colorizer.lua" },
  -- colorscheme
  { "astrotheme" },
  -- utility
  { "better-escape.nvim" },
  -- deltavim.plugins.colorshceme
  { "tokyonight.nvim" },
  { "catppuccin" },
  -- deltavim.plugins.editor
  { "neo-tree.nvim" },
  { "toggleterm.nvim" },
  { "nvim-spectre" },
  { "telescope.nvim" },
  { "which-key.nvim" },
  { "gitsigns.nvim" },
  { "vim-illuminate" },
  { "mini.bufremove" },
  { "trouble.nvim" },
  { "todo-comments.nvim" },
  -- deltavim.plugins.lsp
  { "nvim-lspconfig" },
  { "none-ls.nvim" },
  { "mason.nvim" },
  -- deltavim.plugins.ui
  { "nvim-notify" },
  { "dressing.nvim" },
  { "bufferline.nvim" },
  { "mini.bufremove" },
  { "barbecue.nvim" },
  { "lualine.nvim" },
  { "indent-blankline.nvim" },
  { "mini.indentscope" },
  { "noice.nvim" },
  { "alpha-nvim" },
  { "nvim-navic" },
  { "nvim-web-devicons" },
  { "nui.nvim" },
  -- deltavim.plugins.util
  { "vim-startuptime" },
  { "persistence.nvim" },
}

for _, name in ipairs(plugins) do
  name.cond = false
end

---@diagnostic disable-next-line:missing-parameter
return require("deltavim.utils").concat(plugins, {
  -- disable some treesitter modules
  {
    "nvim-treesitter",
    opts = { highlight = { enable = false } },
  },
})
