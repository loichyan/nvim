---@type MeoSpec
local Spec = { "MagicDuck/grug-far.nvim", event = "VeryLazy" }

---@param scope "current"|"all"
local open = function(scope)
  local paths
  if scope == "current" then paths = vim.fn.expand("%") end
  require("grug-far").open({ prefills = { paths = paths } })
end

Spec.config = function()
  require("grug-far").setup({
    enabledEngines = { "ripgrep", "astgrep" },
    -- stylua: ignore
    keymaps = {
      replace       = { n = "<CR>", i = "<M-CR>" },
      qflist        = "<C-q>",
      syncLocations = "<C-s>",
      syncLine      = "<C-l>",
      swapEngine    = "<C-e>",
      close         = { n = "q", i = "<C-c>" },
      gotoLocation  = { n = "o", i = "<C-o>" },
    },
  })

  Meow.autocmd("meowim.plugins.grug-far", {
    {
      event = "FileType",
      pattern = "grug-far",
      desc = "Tweak GrugFar buffers",
      command = "setlocal conceallevel=0",
    },
  })

  -- stylua: ignore
  Meow.keymap({
    { "<Leader>r", function() open("current") end, desc = "Search and replace in current buffer" },
    { "<Leader>R", function() open("all") end,     desc = "Search and replace in workspace"      },
  })
end

return Spec
