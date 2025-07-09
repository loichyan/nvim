---@type MeoSpec
return {
    "nvimdev/phoenix.nvim",
    lazy = true,
    config = function()
        vim.g.phoenix = {
            dict = {
                capacity = 50000,
                min_word_length = 2,
                word_pattern = "[%@%-%_%a]+",
            },
        }
    end,
}
