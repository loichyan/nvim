---@type LazyPluginSpec
return {
  "astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    local g, opt = opts.options.g, opts.options.opt

    g.tex_flavor = "latex"

    opt.cmdheight = 1
    opt.clipboard = "unnamed"
    opt.conceallevel = 0
    opt.guifont = "monospace:h11"
    opt.swapfile = false
    if vim.g.vscode then
      opt.timeoutlen = 500
    else
      opt.timeoutlen = 300
    end
  end,
}
