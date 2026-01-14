local Config = {}

---@param bufnr number
Config.buf_delete = function(bufnr)
  local ok, bufremove = pcall(require, 'mini.bufremove')
  if ok then
    bufremove.delete(bufnr)
  else
    vim.api.nvim_buf_delete(bufnr, { force = false })
  end
end

return Config
