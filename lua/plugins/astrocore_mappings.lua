---@type LazyPluginSpec
return {
  "astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    local utils, map = require "deltavim.utils", assert(opts.mappings)
    utils.merge(map.n, {
      ["]x"] = "qf-helper.next_quickfix",
      ["[x"] = "qf-helper.prev_quickfix",
      ["<C-n>"] = "qf-helper.next_quickfix",
      ["<C-p>"] = "qf-helper.prev_quickfix",

      ["<C-x>"] = "qf-helper.toggle_quickfix",
      ["<Leader>x"] = "qf-helper.toggle_quickfix",

      ["<Leader>fr"] = "spectre.find_replace",
      ["<Leader>fR"] = "spectre.find_replace_current",

      ["<Leader>gd"] = "diffview.open",
      ["<Leader>gD"] = "diffview.open_last_commit",
      ["<Leader>gh"] = "diffview.open_file_history",
    })

    if vim.g.vscode then
      utils.merge(map.n, {
        ["[["] = { function() vim.fn.VSCodeNotify "references-view.prev" end },
        ["]]"] = { function() vim.fn.VSCodeNotify "references-view.next" end },
        ["<C-,>"] = { function() vim.fn.VSCodeNotify "workbench.action.previousEditor" end },
        ["<C-.>"] = { function() vim.fn.VSCodeNotify "workbench.action.nextEditor" end },
        ["<Leader>,"] = { function() vim.fn.VSCodeNotify "workbench.action.quickOpen" end },
        ["<Leader>w"] = { function() vim.fn.VSCodeNotify "workbench.action.closeActiveEditor" end },
        ["<Leader>la"] = { function() vim.fn.VSCodeNotify "keyboard-quickfix.openQuickFix" end },
      })
    end
  end,
}
