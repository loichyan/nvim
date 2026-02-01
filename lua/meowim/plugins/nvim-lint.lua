---@type MeoSpec
local Spec = { 'mfussenegger/nvim-lint', event = 'LazyFile' }

Spec.config = function()
  local lint = require('lint')
  lint.linters_by_ft = {
    -- text = { 'vale' },
    -- markdown = { 'vale' },
    -- rst = { 'vale' },
    dockerfile = { 'hadolint' },
  }

  Meow.autocmd('meowim.plugins.nvim-lint', {
    {
      event = { 'BufReadPost', 'BufWritePost', 'InsertLeave' },
      desc = 'Lint current buffer',
      callback = Meow.debounce(150, vim.schedule_wrap(function() require('lint').try_lint() end)),
    },
  })
end

return Spec
