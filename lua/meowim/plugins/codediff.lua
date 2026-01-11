---@type MeoSpec
local Spec = {
  "esmuellert/codediff.nvim",
  event = "VeryLazy",
  dependencies = { { "MunifTanjim/nui.nvim" } },
}

Spec.config = function()
  require("codediff").setup({
    explorer = {
      width = 30,
      height = 15,
      icons = { folder_closed = "󰉋", folder_open = "󰝰" },
      view_mode = "list",
    },

    -- stylua: ignore
    highlights = {
      line_insert            = "DiffAdd",
      line_delete            = "DiffDelete",

      char_insert            = "DiffTextAdd",
      char_delete            = "DiffTextDelete",

      conflict_sign          = "DiagnosticSignWarn",
      conflict_sign_resolved = "DiagnosticSignHint",
      conflict_sign_accepted = "DiagnosticSignOk",
      conflict_sign_rejected = "DiagnosticSignError",
    },

    -- stylua: ignore
    keymaps = {
      view = {
        quit             = "q",
        toggle_explorer  = "<leader>e",
        next_hunk        = "<C-n>",
        prev_hunk        = "<C-p>",
        next_file        = "<C-f>",
        prev_file        = "<C-b>",
        diff_get         = "do",
        diff_put         = "dp",
      },
      explorer = {
        select           = "o",
        hover            = "K",
        refresh          = "R",
        toggle_view_mode = "i",
        toggle_stage     = "-",
        stage_all        = "S",
        unstage_all      = "U",
        restore          = "X",
      },
      conflict = {
        accept_incoming  = "c2",
        accept_current   = "c3",
        accept_both      = "c1",
        discard          = "c0",
        next_conflict    = "<C-n>",
        prev_conflict    = "<C-p>",
        diffget_incoming = "2do",
        diffget_current  = "3do",
      },
    },
  })
end

return Spec
