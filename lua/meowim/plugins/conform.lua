---Uses compact placehodler format. Namely, convert `{{ var }}` to `{{var}}`.
---@type conform.LuaFormatterConfig
local compact_placeholder = {
    format = function(_, _, lines, callback)
        local new_lines = {}
        for _, line in ipairs(lines) do
            line = line:gsub([[%{%{%s+([_%w]+)%s+%}%}]], "{{%1}}")
            table.insert(new_lines, line)
        end
        callback(nil, new_lines)
    end,
}

local config = function()
    local by_ft = {
        fish = { "fish_indent" },
        go = { "gofumpt" },
        just = { "just", "compact_placeholder" },
        lua = { "stylua" },
        nix = { "nixfmt" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
    }

    -- Copied from <https://github.com/nvimtools/none-ls.nvim/blob/db2a48b79cfcdab8baa5d3f37f21c78b6705c62e/lua/null-ls/builtins/formatting/prettier.lua#L21>
    for _, ft in ipairs({
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "css",
        "scss",
        "less",
        "html",
        "json",
        "jsonc",
        "yaml",
        "markdown",
        "markdown.mdx",
        "graphql",
        "handlebars",
        "svelte",
        "astro",
        "htmlangular",
    }) do
        by_ft[ft] = { "dprint" }
    end

    local conform = require("conform")
    conform.setup({
        default_format_opts = {
            timeout_ms = 3000,
            async = false,
            quiet = false,
            lsp_format = "fallback",
        },
        formatters = {
            -- TODO: enable injected formatters
            -- injected = { options = { ignore_errors = true } },
            ---@diagnostic disable-next-line: assign-type-mismatch
            compact_placeholder = compact_placeholder,
        },
        formatters_by_ft = by_ft,
    })
    conform.formatters.rustfmt = function(_)
        return {
            command = vim.fn.executable("rustfmt-nightly") == 1 and "rustfmt-nightly" or "rustfmt",
        }
    end
    -- conform.formatters.rustfmt
    vim.api.nvim_create_autocmd("BufWritePre", {
        desc = "Format on save",
        callback = function(ev)
            if not require("meowim.utils").is_toggle_on(ev.buf, "autoformat_disabled") then
                require("mini.trailspace").trim()
                require("conform").format()
            end
        end,
    })
end

---@type MeoSpec
return { "stevearc/conform.nvim", event = "LazyFile", config = config }
