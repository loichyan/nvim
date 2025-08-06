---@type MeoSpec
local Spec = { "mfussenegger/nvim-lint", event = "LazyFile" }

Spec.config = function()
  local lint = require("lint")
  lint.linters_by_ft = {
    text = { "vale" },
    markdown = { "vale" },
    rst = { "vale" },
    dockerfile = { "hadolint" },
  }

  Meow.autocmd("meowim.plugins.nvim-lint", {
    {
      event = { "BufWritePost", "BufReadPost", "InsertLeave" },
      desc = "Lint current buffer",
      -- stylua: ignore
      callback = require("snacks").util.debounce(function() require("lint").try_lint() end, { ms = 150 }),
    },
  })
end

return Spec
