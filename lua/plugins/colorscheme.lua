---@type LazySpec
return {
  {
    "astrotheme",
    opts = {
      highlights = {
        global = {
          ---@param c AstroThemePalette
          modify_hl_groups = function(hl, c)
            hl.LeapBackdrop = { fg = c.syntax.mute }
            hl.LeapMatch = { fg = c.ui.green, bold = true }
            hl.LeapLabelPrimary = { fg = c.ui.red, bold = true }
            hl.LeapLabelSecondary = { fg = c.ui.cyan, bold = true }
          end,
        },
      },
    },
  },
}
