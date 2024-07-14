---@type LazyPluginSpec
return {
  "conform.nvim",
  opts = function(_, opts)
    local by_ft = {
      ["*"] = { "trim_whitespace" },
      fish = { "fish_indent" },
      go = { "gofumpt" },
      just = { "just" },
      lua = { "stylua" },
      nix = { "nixfmt" },
      python = { "black" },
      sh = { "shfmt" },
    }

    for _, ft in ipairs {
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
    } do
      by_ft[ft] = { "prettierd" }
    end

    opts.formatters_by_ft = by_ft
  end,
}
