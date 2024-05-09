---@type LazySpec
return {
  {
    "astroui",
    ---@type AstroUIOpts
    opts = {
      colorscheme = "catppuccin",
    },
  },

  {
    "catppuccin",
    lazy = true,
    opts = {
      flavour = "mocha",
      custom_highlights = function(c)
        return require("deltavim.utils").merge({
          LeapMatch = { fg = c.lavender, bold = true },
          LeapLabelPrimary = { fg = c.red, bold = true },
          LeapLabelSecondary = { fg = c.peach, bold = true },
          LeapBackdrop = { fg = c.overlay0 },
        }, require "deltavim.plugins.catppuccin.opts_highlights"(c))
      end,
    },
  },
}
