---@type LazyPluginSpec
return {
  "astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    local utils, map = require "deltavim.utils", assert(opts.mappings)
    require "astrocore"
    utils.make_mappings(map, {
      n = {
        ["<M-r>"] = { "<Cmd>checktime<CR>" },

        ["<C-H>"] = false,
        ["<C-J>"] = false,
        ["<C-K>"] = false,
        ["<C-L>"] = false,

        ["<C-S-h>"] = false,
        ["<C-S-j>"] = false,
        ["<C-S-k>"] = false,
        ["<C-S-l>"] = false,

        ["<M-h>"] = "smart-splits.left_window",
        ["<M-j>"] = "smart-splits.down_window",
        ["<M-k>"] = "smart-splits.up_window",
        ["<M-l>"] = "smart-splits.right_window",

        ["<M-H>"] = "smart-splits.resize_left",
        ["<M-J>"] = "smart-splits.resize_down",
        ["<M-K>"] = "smart-splits.resize_up",
        ["<M-L>"] = "smart-splits.resize_right",

        ["]x"] = "qf-helper.next_quickfix",
        ["[x"] = "qf-helper.prev_quickfix",
        ["<C-N>"] = "qf-helper.next_quickfix",
        ["<C-P>"] = "qf-helper.prev_quickfix",

        ["<Leader>x"] = "quicker.toggle_quickfix",

        ["<Leader>fr"] = "grug-far.find_replace_sg",
        ["<Leader>fR"] = "grug-far.find_replace_rg",

        ["<Leader>gd"] = "diffview.open",
        ["<Leader>gD"] = "diffview.open_last_commit",
        ["<Leader>gh"] = "diffview.open_file_history",
      },
    })

    if vim.g.vscode then
      utils.make_mappings(map, {
        n = {
          ["[["] = {
            function() vim.fn.VSCodeNotify "references-view.prev" end,
          },
          ["]]"] = {
            function() vim.fn.VSCodeNotify "references-view.next" end,
          },
          ["<C-,>"] = {
            function() vim.fn.VSCodeNotify "workbench.action.previousEditor" end,
          },
          ["<C-.>"] = {
            function() vim.fn.VSCodeNotify "workbench.action.nextEditor" end,
          },
          ["<Leader>,"] = {
            function() vim.fn.VSCodeNotify "workbench.action.quickOpen" end,
          },
          ["<Leader>w"] = {
            function() vim.fn.VSCodeNotify "workbench.action.closeActiveEditor" end,
          },
          ["<Leader>la"] = {
            function() vim.fn.VSCodeNotify "keyboard-quickfix.openQuickFix" end,
          },
        },
      })
    end
  end,
}
