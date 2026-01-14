local Theme = require('meoline.internal.theme')
local Winbar = {}
local H = setmetatable({}, { __index = require('meoline.internal.utils') })

---@class MeolineWinbarItem
---@field text       string  -- text to display
---@field icon?      string  -- icon preceding text
---@field icon_hl?   string  -- highlight group of icon
---@field on_click? fun(winnr:integer,n_clicks:integer,button:string) -- callback on click

--------------------------------------------------------------------------------
-- Main winbar -----------------------------------------------------------------
--------------------------------------------------------------------------------

Winbar.eval = function(winnr)
  if not vim.api.nvim_win_is_valid(winnr) then return end
  local items = H.items_per_win[winnr]
  if not items then return '%=' end

  local item_on_click = "@v:lua.require'meoline.internal.winbar'.item_on_click.w" .. winnr .. '@'
  local trunc_char, separator = '  ', '󰥭'

  local winbar, maxwid = {}, vim.api.nvim_win_get_width(winnr)
  maxwid = math.min(maxwid, 80) -- prevent winbar being to long
  maxwid = maxwid - 3 -- leave some space for truncate character

  local is_win_active = winnr == tonumber(vim.g.actual_curwin)
  local active_symbol_hl = Theme.get_hl(is_win_active and 'wbr_active' or 'wbr_visible')
  local visible_symbol_hl = Theme.get_hl(is_win_active and 'wbr_visible' or 'wbr_hidden')

  -- Insert items from right to left, and truncate from left if no space.
  local trunc_at = 1
  for i = #items, 1, -1 do
    local item = items[i]
    local text, icon = item.text, item.icon

    maxwid = maxwid - H.strwidth(text)
    maxwid = maxwid - (icon and H.strwidth(icon) + 1 or 0)
    maxwid = maxwid - 3 -- separator and spaces
    if maxwid < 0 then
      trunc_at = i + 1
      break
    end

    local is_item_active = i == #items
    local text_hl = is_item_active and active_symbol_hl or visible_symbol_hl
    local icon_hl = is_item_active and item.icon_hl or nil

    winbar[#winbar + 1] = ' %T'
    H.list_extend(winbar, '%##', H.escape(item.text), '#', text_hl, ' %#')
    if icon then H.list_extend(winbar, '%##', H.escape(icon), '#', icon_hl or '', ' %#') end -- prepend icon if provided
    H.list_extend(winbar, item_on_click, i, '%') -- make item clickable

    if i > 1 then H.list_extend(winbar, '%##', separator, '%##') end -- not add separator for the leftmost item
  end
  if trunc_at > 1 then H.list_extend(winbar, '%##', trunc_char, '%##') end
  H.list_reverse(winbar) -- items are inserted in reverse order
  winbar[#winbar + 1] = '%='

  return table.concat(winbar)
end

---@type table<integer,MeolineWinbarItem[]>
H.items_per_win = {}

---@param winnr integer
---@param items? MeolineWinbarItem[]
Winbar.update = function(winnr, items)
  local bar = "%{%v:lua.require'meoline'.eval_winbar(" .. winnr .. ')%}'
  local wo = vim.wo[winnr]
  if not items and wo.winbar ~= '' then
    wo.winbar = ''
  elseif items and wo.winbar ~= bar then
    wo.winbar = bar
  end
  H.items_per_win[winnr] = items
  H.redraw_winbar()
end

--------------------------------------------------------------------------------
-- Callback Functions ----------------------------------------------------------
--------------------------------------------------------------------------------

-- Usage: Winbar.item_on_click['w<winnr>'](item, n_clicks, button)
Winbar.item_on_click = setmetatable({}, {
  __index = function(_, key)
    local winnr = tonumber(key:sub(2)) ---@cast winnr -nil
    return function(i, n_clicks, button)
      local on_click = H.items_per_win[winnr][i].on_click
      if on_click then on_click(winnr, n_clicks, button) end
    end
  end,
})

return Winbar
