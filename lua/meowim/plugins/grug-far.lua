---@type MeoSpec
local Spec = { "MagicDuck/grug-far.nvim", event = "LazyFile" }
local M = {}

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
end

---Search and replace in current buffer or across workspace files.
---@param scope "buffer"|"workspace"
function M.open(scope)
  local path
  if scope == "buffer" then
    path = vim.fn.expand("%")
    path = vim.uv.fs_stat(path) and path or nil
  end
  require("grug-far").open({ prefills = { paths = path } })
end

M[1] = Spec
return M
