local Colors = require("meoline.internal.colors")
local Statusline = {}
local H = {}

--------------------------------------------------------------------------------
-- Main statusline -------------------------------------------------------------
--------------------------------------------------------------------------------

Statusline.eval = function()
  local stline = {}

  local section_joint = function(hl, ...) -- append with higroup surround
    H.stl_extend(stline, "%#", Colors.get(hl), "#", ...)
    stline[#stline + 1] = "%##"
  end
  local section = function(hl, ...)
    stline[#stline + 1] = " "
    section_joint(hl, ...)
  end

  ------------------------
  -- colored mode block --
  ------------------------
  local mode = vim.fn.mode()
  local mode_hl = Colors.mode_higroups[mode]
  section_joint(mode_hl, "┃")

  ---------------------------
  -- workspace information --
  ---------------------------
  section("stl_workspace", vim.fn.fnamemodify(H.root, ":t"))

  local gitinfo = H.gitinfo
  if gitinfo ~= nil then
    section("stl_gitinfo", "󰘬 ", gitinfo.head, gitinfo.in_progress and "|", gitinfo.in_progress)
  end

  local diaginfo = H.diagnostic_counts
  for _, diag in ipairs(Colors.diagnostic_sections) do
    if (diaginfo[diag[1]] or 0) > 0 then section(diag.hl, diag.icon, diaginfo[diag[1]]) end
  end

  ----------------------
  -- file information --
  ----------------------
  if vim.api.nvim_win_get_config(0).relative == "" then -- not update filename for floating windows
    H.file_bufnr = vim.api.nvim_get_current_buf()
  end
  local file_bufnr = H.file_bufnr or 0
  if not vim.api.nvim_buf_is_valid(file_bufnr) then file_bufnr = 0 end

  do
    local bo = vim.bo[file_bufnr]
    local bufname = vim.api.nvim_buf_get_name(file_bufnr)

    if bufname == "" then
      section("stl_filename", "[No Name]")
    elseif bo.buftype == "terminal" then -- show program name for terminals
      local basename = vim.fn.fnamemodify(bufname, ":t")
      section("stl_filename", H.escape(basename))
    else -- show fullpath and attributes for other buffers
      local filename = vim.fn.fnamemodify(bufname, ":~:.")
      if not H.fits_width(100) then filename = vim.fn.pathshorten(filename) end
      section("stl_filename", H.escape(filename))
      if not bo.modifiable then section_joint("stl_fileinfo", "[-]") end
      if bo.readonly then section_joint("stl_fileinfo", "[RO]") end
    end
  end

  local diffinfo = vim.b[file_bufnr].minidiff_summary or {}
  for _, diff in ipairs(Colors.diff_sections) do
    if (diffinfo[diff[1]] or 0) > 0 then section(diff.hl, diff.icon, diffinfo[diff[1]]) end
  end

  stline[#stline + 1] = "%<%=" -- end of left sections

  -------------------------
  -- cmdline information --
  -------------------------
  if vim.o.cmdheight == 0 then
    section("stl_showcmd", "%S")

    local current, total = H.searchcount()
    if current then section("stl_searchcount", " ", current, "/", total) end

    local recording = vim.fn.reg_recording()
    if recording ~= "" then section("stl_recording", "󰵝 ", recording) end
  end

  ------------------------
  -- buffer information --
  ------------------------
  local bufnr = vim.api.nvim_get_current_buf()
  local curline, curcol, totaline = vim.fn.line("."), vim.fn.charcol("."), vim.fn.line("$")
  local bufsize = vim.fn.line2byte(totaline + 1) - 1

  local lspinfo = H.lsp_clients[bufnr]
  if lspinfo and H.fits_width(100) then section("stl_bufinfo", "󰰎 ", lspinfo) end

  do
    local bo = vim.bo
    local filetype = bo.filetype
    local icon = H.get_icon("filetype", filetype)

    if filetype == "" then
      section("stl_bufinfo", icon, " ", H.bytesize(bufsize))
    elseif H.fits_width(100) and bo.buftype == "" then -- show metadata of normal buffer
      section(
        "stl_bufinfo",
        icon,
        " ",
        filetype,
        " ",
        H.empty_or(bo.fileencoding, vim.o.encoding),
        "[",
        H.empty_or(bo.fileformat, vim.o.fileformat),
        "]",
        " ",
        H.bytesize(bufsize)
      )
    else -- show only filetype for others
      section("stl_bufinfo", icon, " ", filetype)
    end
  end

  section(
    "stl_location",
    string.format("%2d", curcol),
    "|",
    curline == 1 and "Top"
      or curline == totaline and "Bot"
      or string.format("%2d%%%%", curline / totaline * 100)
  )

  ------------------------
  -- colored mode block --
  ------------------------
  section(mode_hl, "┃")

  return table.concat(stline)
end

--------------------------------------------------------------------------------
-- Helper functions ------------------------------------------------------------
--------------------------------------------------------------------------------

H.searchcount = function()
  if vim.v.hlsearch == 0 then return end
  local ok, searchcount = pcall(vim.fn.searchcount)
  if not ok or not searchcount.total then return end
  if searchcount.total == 0 or searchcount.incomplete == 1 then return "?", "?" end
  return searchcount.current, math.min(searchcount.total, searchcount.maxcount)
end

H.bytesize = function(size)
  if size < 1024 then
    return string.format("%dB", size)
  elseif size < 1048576 then
    return string.format("%.2fKiB", size / 1024)
  else
    return string.format("%.2fMiB", size / 1048576)
  end
end

H.empty_or = function(a, b) return a ~= "" and a or b end
H.escape = function(s) return string.gsub(s, "%%", "%%%%"), nil end
H.fits_width = function(width) return vim.o.columns >= width end
H.get_icon = require("mini.icons").get

H.stl_extend = function(dst, ...)
  for _, val in ipairs({ ... }) do
    if dst then dst[#dst + 1] = val end
  end
end

--------------------------------------------------------------------------------
-- Autocommands ----------------------------------------------------------------
--------------------------------------------------------------------------------

H.augroup = vim.api.nvim_create_augroup("meoline.statusline", { clear = true })

---@param opts vim.api.keyset.create_autocmd
H.autocmd = function(event, opts)
  opts.group = H.augroup
  vim.api.nvim_create_autocmd(event, opts)
end

H.debounce = function(ms, f)
  local timer = vim.uv.new_timer() ---@cast timer -nil
  return function(a1, a2, a3)
    timer:stop()
    timer:start(ms, 0, function() f(a1, a2, a3) end)
  end
end

H.diagnostic_counts = {} -- per severity
H.autocmd("DiagnosticChanged", {
  callback = H.debounce(150, function()
    local counts = {}
    H.diagnostic_counts = counts
    for _, diag in ipairs(vim.diagnostic.get()) do
      counts[diag.severity] = (counts[diag.severity] or 0) + 1
    end
    vim.schedule(function() vim.cmd("redrawstatus") end)
  end),
})

H.lsp_clients = {} -- per buffer
H.autocmd({ "LspAttach", "LspDetach" }, {
  group = H.augroup,
  callback = function(ev)
    local count = #vim.lsp.get_clients({ bufnr = ev.buf })
    H.lsp_clients[ev.buf] = count > 0 and string.rep("+", count) or nil
    vim.schedule(function() vim.cmd("redrawstatus") end)
  end,
})

H.root = vim.fn.getcwd()
H.gitinfo = nil
H.gitinfo_per_root = {}
H.autocmd("DirChanged", {
  callback = function(ev)
    H.root = ev.file
    H.gitinfo = H.gitinfo_per_root[ev.file]
  end,
})
H.autocmd("User", {
  pattern = "MiniGitUpdated",
  callback = function(ev)
    local git = vim.b[ev.buf].minigit_summary or {}
    if not git.root or not git.head then return end

    local head = git.head_name or "HEAD"
    head = head == "HEAD" and git.head:sub(1, 7) or head
    head = head:gsub("^heads/", "")
    local in_progress = git.in_progress ~= "" and git.in_progress or nil
    local info = { head = head, in_progress = in_progress }

    H.gitinfo_per_root[git.root] = info
    if git.root == H.root then H.gitinfo = info end
  end,
})

return Statusline
