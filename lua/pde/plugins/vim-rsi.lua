---@type LazyPluginSpec
return { "tpope/vim-rsi", cond = not vim.g.vscode, event = { "CmdlineEnter", "InsertEnter" } }
