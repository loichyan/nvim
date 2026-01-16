local Config = {}
local H = {}

---@param bufnr integer
Config.buf_delete = function(bufnr)
  local ok, minibufrm, snacksbufdel

  ok, minibufrm = pcall(require, 'mini.bufremove')
  if ok then return minibufrm.delete(bufnr, false) end

  ok, snacksbufdel = pcall(require, 'snacks.bufdelete')
  if snacksbufdel then return snacksbufdel.delete({ buf = bufnr, force = false }) end

  vim.api.nvim_buf_delete(bufnr, { force = false })
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

return Config
