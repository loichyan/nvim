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
        "css",
        "graphql",
        "handlebars",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "jsonc",
        "less",
        "markdown",
        "markdown.mdx",
        "scss",
        "typescript",
        "typescriptreact",
        "vue",
        "yaml",
    }) do
        by_ft[ft] = { "prettierd" }
    end

    require("conform").setup({
        default_format_opts = {
            timeout_ms = 3000,
            async = false,
            quiet = false,
            lsp_format = "fallback",
        },
        formatters = {
            injected = { options = { ignore_errors = true } },
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
