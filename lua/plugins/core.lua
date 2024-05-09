return {
  {
    "astrocore",
    ---@param opts AstroCoreOpts
    opts = function(_, opts)
      local utils = require "deltavim.utils"
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

      local autocmd = opts.autocmds
      autocmd.ruler = {
        {
          event = "FileType",
          callback = function()
            local o = vim.opt_local
            ---@diagnostic disable-next-line: undefined-field
            if o.buflisted:get() == true then o.colorcolumn = { 80 } end
          end,
        },
      }

      local map = assert(opts.mappings)
      utils.make_mappings(map, {
        n = {
          ["<Leader>fr"] = "spectre.find_replace",
          ["<Leader>fR"] = "spectre.find_replace_current",

          ["<Leader>gd"] = "diffview.open",
          ["<Leader>gD"] = "diffview.open_last_commit",
          ["<Leader>gh"] = "diffview.open_file_history",
        },
      })

      if vim.g.vscode then
        utils.merge(map.n, {
          { "[[", function() vim.fn.VSCodeNotify "references-view.prev" end },
          { "]]", function() vim.fn.VSCodeNotify "references-view.next" end },
          { "<C-,>", function() vim.fn.VSCodeNotify "workbench.action.previousEditor" end },
          { "<C-.>", function() vim.fn.VSCodeNotify "workbench.action.nextEditor" end },
          { "<Leader>,", function() vim.fn.VSCodeNotify "workbench.action.quickOpen" end },
          { "<Leader>w", function() vim.fn.VSCodeNotify "workbench.action.closeActiveEditor" end },
          { "<Leader>la", function() vim.fn.VSCodeNotify "keyboard-quickfix.openQuickFix" end },
        })
      end
    end,
  },
}
