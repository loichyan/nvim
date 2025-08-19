---@type MeoSpec
local Spec = { "mini.misc", event = "VeryLazy" }
local M = {}

Spec.config = function()
  local minimisc = require("mini.misc")
  minimisc.setup({ make_global = { "put", "put_text", "bench_time", "stat_summary" } })
  minimisc.setup_restore_cursor()
  minimisc.setup_auto_root({ ".git" })

  -- TODO: report to mini.misc?
  -- Ensure target for `find_root` is a valid buffer
  ---@diagnostic disable-next-line: duplicate-set-field
  minimisc.find_root = Meowim.utils.wrap_fn(minimisc.find_root, function(find_root, bufnr, ...)
    bufnr = bufnr or 0
    if vim.bo[bufnr].buftype ~= "" then return end
    return find_root(bufnr, ...)
  end)
end

---Zooms in/out current buffer.
function M.zoom()
  local title = " Zoom |" .. vim.fn.expand(".") .. " "
  if not require("mini.misc").zoom(0, { title = title }) then return end
  vim.wo.winhighlight = "NormalFloat:Normal"
end

M[1] = Spec
return M
