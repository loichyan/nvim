local Meoline = {}

---@class MeolineOptions
---@field statusline? boolean
---@field tabline? boolean
---@field palette? table<string,string>|fun():table<string,string>

---@param opts? MeolineOptions
Meoline.setup = function(opts)
  opts = opts or {}

  if opts.statusline ~= false then
    Meoline.eval_statusline = require("meoline.internal.statusline").eval
    vim.o.statusline = "%{%v:lua.require'meoline'.eval_statusline()%}"
  end

  if opts.tabline ~= false then
    Meoline.eval_tabline = require("meoline.internal.tabline").eval
    vim.o.tabline = "%{%v:lua.require'meoline'.eval_tabline()%}"
  end

  vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Update colors for Meoline",
    callback = function()
      require("meoline.internal.colors").update(
        type(opts.palette) == "function" and opts.palette() or opts.palette
      )
    end,
  })
end

return Meoline
