---@type LazySpec
return {
  {
    "astroui",
    ---@type AstroUIOpts
    opts = {
      status = {
        separators = {
          left = { "", "" },
          right = { "", "" },
          tab = { "", "" },
        },
      },
    },
  },

  -- diffview/merge tool
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    opts = function() return require "plugins.diffview.opts" end,
  },

  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
  },
}
