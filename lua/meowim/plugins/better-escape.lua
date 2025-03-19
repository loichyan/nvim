---@type MeoSpec
return {
    "max397574/better-escape.nvim",
    lazy = true,
    config = function()
        require("better_escape").setup({
            timeout = 300,
            default_mappings = false,
            mappings = {
                i = { j = { k = "<Esc>", j = "<Esc>" } },
            },
        })
    end,
}
