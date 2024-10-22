---@type LazyPluginSpec
return {
  "brianhuster/live-preview.nvim",
  cond = not vim.g.vscode,
  ft = "markdown",

  opts = {
    commands = {
      start = "LivePreview",
      stop = "StopPreview",
    },
  },
  config = function(_, opts)
    require("livepreview").setup(opts)

    local function toggle_preview()
      if vim.g.livepreview_opened then
        vim.cmd(opts.commands.stop)
        vim.g.livepreview_opened = false
      else
        vim.cmd(opts.commands.start)
        vim.g.livepreview_opened = true
      end
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function(args)
        vim.keymap.set("n", "<Leader>lp", toggle_preview, {
          desc = "Toggle markdown preview",
          buffer = args.buf,
        })
      end,
    })
  end,
}
