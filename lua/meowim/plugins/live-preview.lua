---@type MeoSpec
return {
  'brianhuster/live-preview.nvim',
  ft = 'markdown',
  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function(ev)
        vim.keymap.set(
          'n',
          '<Leader>lp',
          '<Cmd>LivePreview start<CR>',
          { buffer = ev.buf, desc = 'LivePreview', silent = true }
        )
      end,
    })
  end,
}
