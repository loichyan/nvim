---@type LazyPluginSpec
return {
  "catppuccin",
  opts = function(_, opts)
    opts.flavour = "mocha"
    local prev_highlights = opts.custom_highlights
    opts.custom_highlights = function(c)
      return require("deltavim.utils").merge({
        LeapMatch = { fg = c.lavender, bold = true },
        LeapLabelPrimary = { fg = c.red, bold = true },
        LeapLabelSecondary = { fg = c.peach, bold = true },
        LeapBackdrop = { fg = c.overlay0 },
      }, prev_highlights and prev_highlights(c) or {})
    end
  end,
}
