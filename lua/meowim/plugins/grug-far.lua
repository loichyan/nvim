---@type MeoSpec
return {
    "MagicDuck/grug-far.nvim",
    event = "VeryLazy",
    config = function()
        require("grug-far").setup({
            -- stylua: ignore
            keymaps = {
                replace       = { n = "<CR>", i = "<M-CR>" },
                qflist        = "<C-q>",
                syncLocations = "<C-s>",
                syncLine      = "<C-l>",
                swapEngine    = "<C-e>",
                close         = { n = "q", i = "<C-c>" },
                gotoLocation  = { n = "o", i = "<C-o>" },
            },
        })

        Meow.keyset({
            {
                "<Leader>r",
                function()
                    require("grug-far").open({
                        prefills = {
                            paths = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":."),
                        },
                    })
                end,
                desc = "Search and replace in current buffer",
            },
            {
                "<Leader>R",
                function() require("grug-far").open() end,
                desc = "Search and replace in workspace",
            },
        })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "grug-far",
            command = "setlocal conceallevel=0",
            desc = "Turn off 'conceallevel' when GrugFar is open",
        })
    end,
}
