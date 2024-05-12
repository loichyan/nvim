---@type LazyPluginSpec
return {
  "catppuccin",
  opts = function(_, opts)
    local utils, prev_highlights = require "deltavim.utils", opts.custom_highlights
    utils.deep_merge(opts, {
      flavour = "mocha",
      integrations = { diffview = true },
      custom_highlights = function(c)
        return utils.merge({
          LeapMatch = { fg = c.lavender, bold = true },
          LeapLabelPrimary = { fg = c.red, bold = true },
          LeapLabelSecondary = { fg = c.peach, bold = true },
          LeapBackdrop = { fg = c.overlay0 },
        }, prev_highlights and prev_highlights(c) or {})
      end,
    })
  end,
}
