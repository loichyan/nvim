---@type MeoSpec
return {
    "folke/snacks.nvim",
    event = "VeryLazy",
    config = function()
        require("snacks").setup({
            bigfile = { enabled = true },
            quickfile = { enabled = true },
            input = { enabled = true },
        })
        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesActionRename",
            callback = function(ev)
                require("snacks.rename").on_rename_file(ev.data.from, ev.data.to)
            end,
        })
    end,
}
