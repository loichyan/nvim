local H = setmetatable({}, { __index = require('meoline.internal.utils') })
local Config = {}

---@param bufnr integer
Config.buf_delete = function(bufnr)
  local ok, minibufrm, snacksbufdel

  ok, minibufrm = pcall(require, 'mini.bufremove')
  if ok then return minibufrm.delete(bufnr, false) end

  ok, snacksbufdel = pcall(require, 'snacks.bufdelete')
  if snacksbufdel then return snacksbufdel.delete({ buf = bufnr, force = false }) end

  vim.api.nvim_buf_delete(bufnr, { force = false })
end

---@param path string
Config.file_open = function(path)
  local ok, minifiles = pcall(require, 'mini.files')
  if ok then return minifiles.open(path) end
  return vim.cmd.edit(path)
end

---@param category 'filetype'|'file'|'lsp'
---@return string,string?
Config.icon_get = function(category, name)
  Config.icon_get = H.default_icon_get()
  return Config.icon_get(category, name)
end

H.default_icon_get = function()
  local ok, miniicons, devicons, lspkind
  ok, miniicons = pcall(require, 'mini.icons')
  if ok then return miniicons.get end

  ok, devicons = pcall(require, 'nvim-web-devicons')
  -- stylua: ignore
  if not ok then devicons = setmetatable({}, { __index = function() return function() return '󰈔' end end }) end

  ok, lspkind = pcall(require, 'lspkind')
  if not ok then lspkind = setmetatable({}, { __index = function() return '' end }) end

  return function(category, name)
    if category == 'filetype' then
      return devicons.get_icon_by_filetype(name, { default = true })
    elseif category == 'file' then
      return devicons.get_icon(name, nil, { default = true })
    elseif category == 'lsp' then
      return lspkind[name]
    else
      error('unknown category: ' .. category)
    end
  end
end

---@param bufnr integer
---@return MeolineWinbarItem[]|nil
Config.winbar_items = function(bufnr)
  if not vim.bo[bufnr].buflisted or vim.bo[bufnr].buftype ~= '' then return end
  local items = {} ---@type MeolineWinbarItem[]

  -- Path segments
  local path = vim.api.nvim_buf_get_name(bufnr)
  path = path == '' and '[No Name]' or vim.fn.fnamemodify(path, ':~:.')
  local path_segments = vim.split(path, H.path_sep, { plain = true })
  for i, segment in ipairs(path_segments) do
    table.insert(items, {
      text = segment,
      on_click = function(_, _, button)
        if button ~= 'l' then return end
        Config.file_open(table.concat(path_segments, H.path_sep, 1, i))
      end,
    })
  end
  -- Add an icon to filename
  do
    local icon, icon_hl = Config.icon_get('file', path)
    items[#items].icon = icon
    items[#items].icon_hl = icon_hl
  end

  -- LSP symbols
  local lsp_symbols = require('nvim-navic').get_data(bufnr) or {}
  for _, symbol in ipairs(lsp_symbols) do
    local icon, icon_hl = Config.icon_get('lsp', symbol.type)
    table.insert(items, {
      text = symbol.name,
      icon = icon,
      icon_hl = icon_hl,
      on_click = function(winnr, _, button)
        if button ~= 'l' then return end
        local start = symbol.scope.start
        vim.api.nvim_win_set_cursor(winnr, { start.line, start.character })
      end,
    })
  end

  return items
end

return Config
