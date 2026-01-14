local Utils = {}

---@class __meoline_utils_autocmd: vim.api.keyset.create_autocmd
---@field event     string|string[]
---@field debounce? integer

---@return fun(opts:__meoline_utils_autocmd)
Utils.make_autocmd = function(group)
  local augroup = vim.api.nvim_create_augroup(group, { clear = true })
  return function(opts)
    local event, debounce = opts.event, opts.debounce
    opts.group, opts.event, opts.debounce = augroup, nil, nil
    if debounce then opts.callback = Utils.debounce(debounce, opts.callback) end
    vim.api.nvim_create_autocmd(event, opts)
  end
end

Utils.debounce = function(ms, f)
  local timer = vim.uv.new_timer() ---@cast timer -nil
  return function(a1, a2, a3)
    timer:stop()
    timer:start(ms, 0, vim.schedule_wrap(function() f(a1, a2, a3) end))
  end
end

Utils.list_extend = function(dst, ...) return Utils.list_concat(dst, { ... }) end
Utils.list_concat = function(dst, src)
  for _, val in ipairs(src) do
    dst[#dst + 1] = val
  end
  return dst
end
Utils.list_reverse = function(dst)
  local n = #dst
  for i = 1, n / 2 do
    dst[i], dst[n - i + 1] = dst[n - i + 1], dst[i]
  end
  return dst
end

-- stylua: ignore start
Utils.empty_or = function(a, b) return a ~= '' and a or b end
Utils.escape = function(s) return string.gsub(s, '%%', '%%%%'), nil end
Utils.has_space = function(len, percent) return (len / vim.o.columns) <= percent end
Utils.strwidth = vim.api.nvim_strwidth

Utils.redraw_tabline = vim.schedule_wrap(function() vim.api.nvim__redraw({ tabline = true }) end)
Utils.redraw_statusline = vim.schedule_wrap(function() vim.api.nvim__redraw({ statusline = true }) end)
Utils.redraw_winbar = vim.schedule_wrap(function() vim.api.nvim__redraw({ winbar = true }) end)
-- stylua: ignore end

return Utils
