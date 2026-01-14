local Meoline = {}

---@class MeolineOptions
---@field statusline? boolean
---@field tabline?    boolean
---@field winbar?     boolean
---@field palette?    table<string,string>|fun():table<string,string>

---@param opts? MeolineOptions
Meoline.setup = function(opts)
  opts = opts or {}

  if opts.statusline ~= false then
    Meoline.eval_statusline = require('meoline.internal.statusline').eval
    vim.o.statusline = "%{%v:lua.require'meoline'.eval_statusline()%}"
  end

  if opts.tabline ~= false then
    Meoline.eval_tabline = require('meoline.internal.tabline').eval
    vim.o.tabline = "%{%v:lua.require'meoline'.eval_tabline()%}"
  end

  if opts.winbar ~= false then
    -- Use `update_winbar` to actually set winbar
    Meoline.eval_winbar = require('meoline.internal.winbar').eval
    Meoline.update_winbar = require('meoline.internal.winbar').update
  end

  local setup_colors = function()
    local palette = type(opts.palette) == 'function' and opts.palette() or opts.palette
    require('meoline.internal.theme').update(palette)
  end
  setup_colors()

  vim.api.nvim_create_autocmd('ColorScheme', {
    desc = 'Update colors for Meoline',
    callback = setup_colors,
  })
end

return Meoline
