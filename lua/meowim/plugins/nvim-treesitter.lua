local config = function()
    -- See <https://github.com/neovim/neovim/issues/32660>
    vim.g._ts_force_sync_parsing = true

    ---@diagnostic disable-next-line:missing-fields
    require("nvim-treesitter.configs").setup({
        sync_install = false,
        ensure_installed = {
            "bash",
            "c",
            "diff",
            "html",
            "lua",
            "luadoc",
            "markdown",
            "markdown_inline",
            "query",
            "vim",
            "vimdoc",
        },
        auto_install = true,
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        incremental_selection = { enable = false },
        indent = { enable = false },
        textobjects = {
            -- stylua: ignore
            move = {
                enable = true,
                goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
                goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
            },
        },
    })
end

---@type MeoSpec
return {
    "nvim-treesitter/nvim-treesitter",
    checkout = "master",
    build = function() vim.cmd("TSUpdate") end,
    event = "LazyFile",
    config = config,
}
