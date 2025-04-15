---@type MeoSpec
return {
    "mini.clue",
    lazy = true,
    config = function()
        local miniclue = require("mini.clue")
        miniclue.setup({
            window = { delay = 250 },
            clues = {
                -- Enhance this by adding descriptions for <Leader> mapping groups
                miniclue.gen_clues.builtin_completion(),
                miniclue.gen_clues.marks(),
                miniclue.gen_clues.registers(),
                miniclue.gen_clues.windows(),
                miniclue.gen_clues.g(),
                miniclue.gen_clues.z(),
                { mode = "n", keys = "<Leader>b", desc = "+Buffers" },
                { mode = "n", keys = "<Leader>f", desc = "+Pickers" },
                { mode = "n", keys = "<Leader>l", desc = "+LSP" },
            },
            triggers = {
                -- builtin_completion
                { mode = "i", keys = "<C-x>" },
                -- marks
                { mode = "n", keys = "'" },
                { mode = "x", keys = "'" },
                { mode = "n", keys = "`" },
                { mode = "x", keys = "`" },
                -- registers
                { mode = "n", keys = '"' },
                { mode = "x", keys = '"' },
                { mode = "i", keys = "<C-r>" },
                { mode = "c", keys = "<C-r>" },
                -- windows
                { mode = "n", keys = "<C-w>" },
                -- g
                { mode = "n", keys = "g" },
                { mode = "x", keys = "g" },
                -- z
                { mode = "n", keys = "z" },
                { mode = "x", keys = "z" },
                -- leaders
                { mode = "n", keys = "<Leader>" },
                { mode = "x", keys = "<Leader>" },
                { mode = "n", keys = "<LocalLeader>" },
                -- bracketed
                { mode = "n", keys = "[" },
                { mode = "n", keys = "]" },
            },
        })
    end,
}
