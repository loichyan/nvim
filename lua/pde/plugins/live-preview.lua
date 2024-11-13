---@type LazyPluginSpec
return {
  "brianhuster/live-preview.nvim",
  cond = not vim.g.vscode,
  ft = "markdown",
  cmd = "LivePreview",

  opts = {
    cmd = "LivePreview",
    port = 5555,
    autokill = true,
  },
  config = function(_, opts)
    require("livepreview").setup(opts)

    local function toggle_preview()
      if vim.g.livepreview_opened == true then
        vim.cmd { cmd = opts.cmd, args = { "close" } }
        vim.g.livepreview_opened = true
      else
        vim.cmd { cmd = opts.cmd, args = { "start" } }
        vim.g.livepreview_opened = false
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
