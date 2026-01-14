local Theme = require('meoline.internal.theme')
local Tabline = {}
local H = setmetatable({}, { __index = require('meoline.internal.utils') })

---@class __meoline_tabline_buftab
---@field id integer
---@field name string
---@field label string
---@field is_active boolean
---@field is_visible boolean

--------------------------------------------------------------------------------
-- Main tabline ----------------------------------------------------------------
--------------------------------------------------------------------------------

Tabline.eval = function()
  local tabline = {}
  local maxwid = vim.o.columns

  local tabpages = vim.api.nvim_list_tabpages()
  local pagelist, pagelistwid
  if #tabpages > 1 then
    pagelist, pagelistwid = H.make_pagelist(tabpages)
    maxwid = maxwid - pagelistwid
  end

  local bufs = H.list_bufs()
  if #bufs > 0 then H.list_concat(tabline, H.make_buflist(bufs, maxwid)) end
  tabline[#tabline + 1] = '%='
  if pagelist then H.list_concat(tabline, pagelist) end

  return table.concat(tabline)
end

H.make_pagelist = function(tabpages)
  local tabpage_on_click = "@v:lua.require'meoline.internal.tabline'.tabpage_on_click@"
  local pagelist, width = {}, 0

  local active_page = vim.api.nvim_get_current_tabpage()
  for tabnr, tabpage in ipairs(tabpages) do
    local hl = Theme.get_hl(tabpage == active_page and 'tbl_activepage' or 'tbl_hiddenpage')
    local label = tostring(tabnr)
    width = width + #label + 2
    H.list_extend(pagelist, '%', tabpage, tabpage_on_click, '%#', hl, '# ', label, ' %##%T')
  end

  return pagelist, width
end

-- The first buffer displayed in each page.
H.anchor_bufnr = {}
-- Show buffers starting from the anchor, regardless of which buffer is active.
H.force_anchor = false

---@param bufs __meoline_tabline_buftab[]
H.make_buflist = function(bufs, maxwid)
  local trunc_on_click = "@v:lua.require'meoline.internal.tabline'.trunc_on_click@"
  local left_trunc, right_trunc = ' 󰄽 ', ' 󰄾 '
  maxwid = maxwid - 6 -- leave some space for truncate characters

  local buflist = {}

  -- Update visibility
  local active_page, visible_bufs = vim.api.nvim_get_current_tabpage(), {}
  for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(active_page)) do
    visible_bufs[vim.api.nvim_win_get_buf(winid)] = true
  end

  -- Locate buffers
  local active_bufnr, anchor_bufnr = vim.api.nvim_get_current_buf(), H.anchor_bufnr[active_page]
  local active_idx, anchor_idx = 1, 1
  for i, buf in ipairs(bufs) do
    buf.is_active = buf.id == active_bufnr
    buf.is_visible = visible_bufs[buf.id] == true
    if buf.is_active then active_idx = i end
    if buf.id == anchor_bufnr then anchor_idx = i end
  end

  if H.force_anchor then active_idx = anchor_idx end
  if anchor_idx > active_idx then anchor_idx = active_idx end

  -- Insert buffers from the active buffer to the anchor (right to left)
  local start_idx = anchor_idx
  for i = active_idx, anchor_idx, -1 do
    local buftab, tabwid = H.make_buftab(bufs[i])
    if tabwid > maxwid then
      start_idx = i + 1
      break
    end
    maxwid = maxwid - tabwid
    for j = #buftab, 1, -1 do
      buflist[#buflist + 1] = buftab[j]
    end
  end
  H.anchor_bufnr[active_page] = bufs[start_idx].id -- update anchor buffer to support pagination

  if start_idx ~= 1 then
    -- stylua: ignore
    H.list_extend(buflist, '%##%T', left_trunc, '#', Theme.get_hl('tbl_trunc'), '%#', trunc_on_click, '%1')
  end
  H.list_reverse(buflist)

  -- Insert buffers from the active buffer to the end (left to right)
  local end_idx = #bufs
  for i = active_idx + 1, #bufs do
    local buftab, tabwid = H.make_buftab(bufs[i])
    if tabwid > maxwid then
      end_idx = i - 1
      break
    end
    maxwid = maxwid - tabwid
    H.list_concat(buflist, buftab)
  end

  if end_idx ~= #bufs then
    -- stylua: ignore
    H.list_extend(buflist, '%2', trunc_on_click, '%#', Theme.get_hl('tbl_trunc'), '#', right_trunc, '%##%T')
  end

  return buflist
end

---@param buf __meoline_tabline_buftab
H.make_buftab = function(buf)
  local buftab_on_click = "@v:lua.require'meoline.internal.tabline'.buftab_on_click@"
  local buftab, width = {}, 0

  local section_joint = function(hl, ...) -- append with higroup surround
    H.list_extend(buftab, '%#', Theme.get_hl(hl), '#')
    for _, val in ipairs({ ... }) do
      if val then
        val = tostring(val)
        buftab[#buftab + 1] = H.escape(val)
        width = width + H.strwidth(val)
      end
    end
    buftab[#buftab + 1] = '%##'
  end
  local section = function(hl, ...)
    buftab[#buftab + 1] = ' '
    width = width + 1
    section_joint(hl, ...)
  end

  -- make it clickable
  local bufnr = buf.id
  H.list_extend(buftab, '%', bufnr, buftab_on_click)

  -----------------------
  -- buffer identifier --
  -----------------------
  local is_active, is_visible = buf.is_active, buf.is_visible

  local label_hl = is_active and 'tbl_active' or is_visible and 'tbl_visible' or 'tbl_hidden'
  section_joint(label_hl, '│')

  local icon, icon_hl = Theme.get_icon('file', buf.name)
  section(is_visible and icon_hl or label_hl, icon)
  section(label_hl, buf.label)

  local info_hl = label_hl .. 'info'
  if vim.bo[bufnr].modified then section_joint(info_hl, '[+]') end

  ------------------------
  -- buffer diagnostics --
  ------------------------
  local diaginfo = H.diagnostic_counts_per_buf[bufnr] or {}
  for _, diag in ipairs(Theme.diagnostic_sections) do
    if (diaginfo[diag[1]] or 0) > 0 then
      section(is_visible and diag.hl or info_hl, diag.icon, diaginfo[diag[1]])
    end
  end

  buftab[#buftab + 1] = '%T ' -- end of clickable label
  return buftab, width + 1
end

--------------------------------------------------------------------------------
-- Callback Functions ----------------------------------------------------------
--------------------------------------------------------------------------------

Tabline.tabpage_on_click = function(tabpage, _, button)
  if button == 'l' then
    vim.api.nvim_set_current_tabpage(tabpage)
  elseif button == 'r' then
    vim.cmd.tabclose(vim.api.nvim_tabpage_get_number(tabpage))
  end
  H.redraw_tabline()
end

Tabline.buftab_on_click = function(bufnr, _, button)
  if button == 'l' then
    vim.api.nvim_win_set_buf(0, bufnr)
  elseif button == 'r' then
    require('meoline.config').buf_delete(bufnr)
  end
  H.redraw_tabline()
end

Tabline.trunc_on_click = function(dir, _, button)
  if button ~= 'l' then return end

  local active_page, bufs = vim.api.nvim_get_current_tabpage(), H.list_bufs()
  local anchor_bufnr, anchor_idx = H.anchor_bufnr[active_page], 1
  for i, buf in ipairs(bufs) do
    if buf.id == anchor_bufnr then anchor_idx = i end
  end

  if dir == 1 then -- left
    H.anchor_bufnr[active_page] = bufs[anchor_idx - 1].id
  elseif dir == 2 then -- right
    H.anchor_bufnr[active_page] = bufs[anchor_idx + 1].id
  else
    error('invalid argument')
  end
  H.force_anchor = true
  H.redraw_tabline()
end

--------------------------------------------------------------------------------
-- Helper functions ------------------------------------------------------------
--------------------------------------------------------------------------------

H.list_bufs = function()
  if not H.listed_bufs then
    local bufs = {} ---@type __meoline_buftab[]
    H.listed_bufs = bufs
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[bufnr].buflisted then
        local path = vim.api.nvim_buf_get_name(bufnr)
        table.insert(bufs, {
          id = bufnr,
          name = path ~= '' and vim.fn.fnamemodify(path, ':~:.') or '',
          label = path ~= '' and vim.fn.fnamemodify(path, ':t') or '*',
        })
      end
    end
    H.dedup_labels(bufs)
  end
  return vim.tbl_filter(function(buf) return vim.api.nvim_buf_is_valid(buf.id) end, H.listed_bufs)
end

H.next_idx = 1
H.assigned_idx = {}
H.path_sep = vim.fn.has('win32') == 1 and '\\' or '/'

---@param bufs __meoline_buftab[]
H.dedup_labels = function(bufs)
  local group_by_label = {}

  for _, buf in ipairs(bufs) do
    local label = buf.label
    group_by_label[label] = group_by_label[label] or {}
    table.insert(group_by_label[label], buf)
  end

  for label, group in pairs(group_by_label) do
    if #group > 1 then
      local did_extend = false
      for _, buf in ipairs(group) do
        local new_label
        if buf.name == '' then
          -- Suffix unnamed buffer with an unique index
          if not H.assigned_idx[buf.id] then
            H.assigned_idx[buf.id] = H.next_idx
            H.next_idx = H.next_idx + 1
          end
          new_label = string.format('%s(%d)', buf.label, H.assigned_idx[buf.id])
        else
          -- Extend label by one component
          local pattern = string.format('[^%s]+%s%s$', H.path_sep, H.path_sep, H.escape(label))
          new_label = string.match(buf.name, pattern) or label
        end
        did_extend = did_extend or buf.label ~= new_label
        buf.label = new_label
      end
      if did_extend then H.dedup_labels(group) end
    end
  end
end

--------------------------------------------------------------------------------
-- Autocommands ----------------------------------------------------------------
--------------------------------------------------------------------------------

H.autocmd = H.make_autocmd('meoline.tabline')

H.diagnostic_counts_per_buf = {}
H.autocmd({
  event = 'DiagnosticChanged',
  debounce = 150,
  callback = function()
    local counts_per_buf = {}
    H.diagnostic_counts_per_buf = counts_per_buf

    for _, diag in ipairs(vim.diagnostic.get()) do
      local buf_counts = counts_per_buf[diag.bufnr] or {}
      counts_per_buf[diag.bufnr] = buf_counts
      buf_counts[diag.severity] = (buf_counts[diag.severity] or 0) + 1
    end

    H.redraw_tabline()
  end,
})

-- Track listed buffers
H.autocmd({
  event = { 'BufAdd', 'BufDelete' },
  callback = function() H.listed_bufs = nil end,
})
H.autocmd({
  event = 'OptionSet',
  pattern = 'buflisted',
  callback = function() H.listed_bufs = nil end,
})
H.autocmd({
  event = 'BufEnter',
  callback = function()
    if vim.bo.buflisted then H.force_anchor = false end
  end,
})

return Tabline
