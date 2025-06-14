local config = function()
    local by_ft = {
        fish = { "fish_indent" },
        go = { "gofumpt" },
        just = { "just" },
        lua = { "stylua" },
        nix = { "nixfmt" },
        sh = { "shfmt" },
    }

    for _, ft in ipairs({
        -- plugin-malva
        "css",
        "less",
        "sass",
        "scss",
        -- plugin-biome
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "json",
        "jsonc",
        -- plugin-pretty_{yaml,graphql}
        "yaml",
        "graphql",
        -- plugin-markup_fmt
        "handlebars",
        "html",
        "jinja",
        "vue",
        -- plugin-markdown
        "markdown",
    }) do
        by_ft[ft] = { "dprint" }
    end

    require("conform").setup({
        default_format_opts = {
            timeout_ms = 3000,
            async = false,
            quiet = false,
            lsp_format = "fallback",
        },
        formatters = {
            -- TODO: enable injected formatters
            -- injected = { options = { ignore_errors = true } },
            dprint = {
                prepend_args = { "--config", vim.fn.expand("~/.config/dprint/config.json") },
            },
        },
        formatters_by_ft = by_ft,
    })
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
