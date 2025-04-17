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
        Meow.keyset({ { "<Leader>r", "<Cmd>GrugFar<CR>", desc = "Open GrugFar" } })
    end,
}
