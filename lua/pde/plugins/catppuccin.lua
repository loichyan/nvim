---@type LazyPluginSpec
return {
  "catppuccin",
  opts = function(_, opts)
    local utils, prev_highlights = require "deltavim.utils", opts.custom_highlights
    utils.deep_merge(opts, {
      flavour = "mocha",
      integrations = {
        diffview = true,
        flash = true,
      },
      transparent_background = true,
      custom_highlights = function(c)
        return utils.merge({
          FlashBackdrop = { fg = c.overlay0 },
          FlashCurrent = { fg = c.green, bold = true },
          FlashLabel = { fg = c.red, bold = true },
          FlashMatch = { fg = c.lavender, bold = true },
        }, prev_highlights and prev_highlights(c) or {})
      end,
    })
  end,
}
