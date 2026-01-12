---@type MeoSpec
local Spec = { "loichyan/meoline.nvim", shadow = true, event = "UIEnter" }
local H = {}

Spec.config = function()
  require("meoline").setup({
    statusline = true,
    table = true,
    winbar = true,
  })

  Meow.autocmd("meowim.plugins.meoline", {
    { event = { "BufWinEnter", "LspAttach" }, callback = H.update_winbar },
    { event = "CursorMoved", debounce = 150, callback = vim.schedule_wrap(H.update_winbar) },
  })
end

H.update_winbar = function()
  local winnr = vim.api.nvim_get_current_win()
  if not vim.api.nvim_win_is_valid(winnr) then return end
  local bufnr = vim.api.nvim_win_get_buf(winnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then return end

  local should_enable = vim.bo.buflisted
    and vim.bo.buftype == ""
    and vim.api.nvim_win_get_config(winnr).relative == ""

  local items = should_enable and H.get_items(bufnr) or nil
  require("meoline").update_winbar(winnr, items)
end

H.get_items = function(bufnr)
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":~:.")
  local path_segments = vim.split(path, H.path_sep, { plain = true })
  local lsp_symbols = require("nvim-navic").get_data(bufnr) or {}

  if #path_segments == 1 and #lsp_symbols == 0 then return nil end
  local items = {} ---@type MeolineWinbarItem[]

  -- Path segments
  for i, segment in ipairs(path_segments) do
    table.insert(items, {
      text = segment,
      on_click = function(_, _, button)
        if button ~= "l" then return end
        require("mini.files").open(table.concat(path_segments, "/", 1, i))
      end,
    })
  end
  -- Add an icon to filename
  do
    local icon, icon_hl = H.get_icon("file", path)
    items[#items].icon = icon
    items[#items].icon_hl = icon_hl
  end

  -- LSP symbols
  for _, symbol in ipairs(lsp_symbols) do
    local icon, icon_hl = H.get_icon("lsp", symbol.type)
    table.insert(items, {
      text = symbol.name,
      icon = icon,
      icon_hl = icon_hl,
      on_click = function(winnr, _, button)
        if button ~= "l" then return end
        local start = symbol.scope.start
        vim.api.nvim_win_set_cursor(winnr, { start.line, start.character })
      end,
    })
  end

  return items
end

H.get_icon = function(...)
  H.get_icon = require("mini.icons").get
  return H.get_icon(...)
end

H.path_sep = vim.fn.has("win32") == 1 and "\\" or "/"

return Spec
