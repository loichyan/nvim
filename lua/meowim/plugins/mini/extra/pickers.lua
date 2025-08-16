local Pickers = {}
local H = {}

---Grep with ast-grep.
---@param local_opts? {tool:string,pattern?:string,globs?:string[]}
function Pickers.grep(local_opts, opts)
  if (local_opts or {}).tool == "ast-grep" then
    return H.ast_grep(local_opts, opts)
  else
    return MiniPick.builtin.grep(local_opts, opts)
  end
end

---Grep with ast-grep.
---@param local_opts? {tool:string,globs?:string[]}
function Pickers.grep_live(local_opts, opts)
  if (local_opts or {}).tool == "ast-grep" then
    return H.ast_grep_live(local_opts, opts)
  else
    return MiniPick.builtin.grep_live(local_opts, opts)
  end
end

---Lists files with a sensible picker.
---@param local_opts? {hidden:boolean}
function Pickers.smart_files(local_opts, opts)
  local_opts = vim.tbl_extend("force", { hidden = false }, local_opts or {})
  local cwd = vim.fn.getcwd()
  local command, postprocess

  if local_opts.hidden then
    command = { "rg", "--files", "--no-follow", "--color=never", "--no-ignore" }
  elseif Meowim.utils.get_git_repo(cwd) == cwd then
  -- stylua: ignore
    command = { "git", "-c", "core.quotepath=false", "ls-files",
                "--exclude-standard", "--deduplicate", "--cached", "--others" }
    local path_exists = function(path) return path ~= "" and vim.uv.fs_stat(path) ~= nil end
    postprocess = function(items) return vim.tbl_filter(path_exists, items) end
  else
    command = { "rg", "--files", "--no-follow", "--color=never" }
  end

  local default_source = {
    name = "Files",
    cwd = cwd,
    show = (H.get_config().source or {}).show or H.show_with_icons,
  }
  opts = vim.tbl_deep_extend("force", { source = default_source }, opts or {})
  return MiniPick.builtin.cli({ command = command, postprocess = postprocess }, opts)
end

---Lists Git conflicts.
---@param local_opts? {tool:string}
function Pickers.git_conflicts(local_opts, opts)
  local_opts = vim.tbl_extend("force", {}, local_opts or {})
  local cwd = vim.fn.getcwd()
  opts = vim.tbl_deep_extend("force", {
    source = {
      name = "Git Conflicts",
      cwd = cwd,
      show = (H.get_config().source or {}).show or H.show_with_icons,
    },
  }, opts or {})
  local grep_opts = { tool = local_opts.tool, pattern = "^<<<<<<< HEAD$" }
  return MiniPick.builtin.grep(grep_opts, opts)
end

---Lists all todo comments of the specified keywords.
---@param local_opts? {scope:"current"|"all",keywords:string[]}
function Pickers.todo(local_opts, opts)
  local_opts = vim.tbl_extend("force", { keywords = { "TODO", "FIXME" } }, local_opts or {})

  local keywords = table.concat(local_opts.keywords, "|")
  local grep_opts = {
    pattern = "\\b(" .. keywords .. ")(\\(.*\\))?:\\s+.+",
    globs = local_opts.scope == "current" and { vim.fn.expand("%") } or nil,
  }

  local name = table.concat(local_opts.keywords, "|")
  opts = vim.tbl_deep_extend("force", { source = { name = name } }, opts or {})
  return MiniPick.builtin.grep(grep_opts, opts)
end

---Lists modified or untracked files.
-- TODO: contribute to mini.extra
function Pickers.git_status(local_opts, opts)
  _ = local_opts

  local default_preview = function(bufnr, item)
    if item.status:find("D") then
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "Deleted" })
    else
      MiniPick.default_preview(bufnr, item)
    end
  end
  local default_source = {
    name = "Git status",
    preview = default_preview,
    show = (H.get_config().source or {}).show or H.show_with_icons,
  }
  opts = vim.tbl_deep_extend("force", { source = default_source }, opts or {})

  local command, postprocess
  command = { "git", "-c", "core.quotepath=false", "status", "--porcelain", "--untracked", "-z" }

  local parse_git_status = function(output)
    local items, entries = {}, vim.split(output, "\0")
    local i = 1
    while i < #entries do
      local entry = entries[i]
      local status, path = entry:sub(1, 2), entry:sub(4)
      local item = { path = path, status = status }
      -- Handle status with two paths
      if status:find("[CR]") then
        i = i + 2
        item.text = string.format("%s %s -> %s", status, entries[i], path)
      else
        i = i + 1
        item.text = entry
      end
      table.insert(items, item)
    end
    return items
  end
  postprocess = function(items)
    if #items == 0 then
      return {}
    else
      return parse_git_status(items[1])
    end
  end

  return MiniPick.builtin.cli({ command = command, postprocess = postprocess }, opts)
end

---Lists notifications from mini.notify.
-- TODO: contribute to mini.extra
---@param local_opts {sources:string[]}
function Pickers.notify(local_opts, opts)
  local_opts = vim.tbl_extend("force", { sources = { "vim.notify" } }, local_opts or {})

  local minintf = require("mini.notify")
  local minintf_config = vim.tbl_deep_extend("force", minintf.config, vim.b.mininotify_config or {})
  local format_notif = minintf_config.format or minintf.default_format

  -- Sort from oldest to newest.
  local notifs = minintf.get_all()
  table.sort(notifs, function(a, b) return a.ts_update < b.ts_update end)

  local items = {}
  for _, notif in pairs(notifs) do
    if vim.tbl_contains(local_opts.sources, notif.data.source) then
      table.insert(items, {
        notif = notif,
        text = vim.gsplit(format_notif(notif), "\n")(),
      })
    end
  end

  -- TODO: add highlights
  local default_preview = function(bufnr, item)
    vim.bo[bufnr].buftype = "nofile"
    vim.bo[bufnr].filetype = "nofile"
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(item.notif.msg, "\n"))
  end
  local default_source = {
    name = "Notifications",
    items = items,
    preview = default_preview,
    choose = function(item)
      local bufnr = vim.api.nvim_create_buf(false, true)
      default_preview(bufnr, item)
      MiniPick.default_choose({ bufnr = bufnr })
    end,
  }
  opts = vim.tbl_deep_extend("force", { source = default_source }, opts or {})
  return MiniPick.start(opts)
end

---Lists registered autocmds.
-- TODO: contribute to mini.extra
function Pickers.autocmds(local_opts, opts)
  -- stylua: ignore
  local fields = {
    { "group_name", "%-30s" },
    { "event",      "%-20s" },
    { "pattern",    "%-25s" },
    { "desc",       "%s"    },
  }
  local format = function(autocmd)
    return table.concat(
      vim.tbl_map(function(f) return string.format(f[2], autocmd[f[1]] or "") end, fields)
    )
  end

  local items = vim.tbl_map(
    function(autocmd) return { au = autocmd, text = format(autocmd) } end,
    vim.api.nvim_get_autocmds(local_opts or {})
  )

  -- Sort by group, then event
  table.sort(items, function(a, b)
    if not a.au.group then
      return false
    elseif not b.au.group then
      return true
    elseif a.au.group == b.au.group then
      return a.au.event < b.au.event
    else
      return a.au.group < b.au.group
    end
  end)

  local default_source = {
    name = "Autocmds",
    items = items,
    preview = function(bufnr, item) MiniPick.default_preview(bufnr, item.au) end,
    choose = function(item)
      -- TODO: report to mini.nvim that choose_print needs schedule
      vim.schedule(function() MiniPick.default_choose(item.au) end)
    end,
  }
  opts = vim.tbl_deep_extend("force", { source = default_source }, opts or {})
  return MiniPick.start(opts)
end

function H.get_config()
  return vim.tbl_deep_extend("force", MiniPick.config, vim.b.minipick_config or {})
end

---Shows items with icons.
function H.show_with_icons(bufnr, items, query, opts)
  return MiniPick.default_show(
    bufnr,
    items,
    query,
    vim.tbl_extend("force", { show_icons = true }, opts or {})
  )
end

---Grep with ast-grep.
---@param local_opts? {tool:string,pattern?:string,globs?:string[]}
-- NOTE: copi-pasted from <https://github.com/echasnovski/mini.nvim/blob/c122e852517adaf7257688e435369c050da113b1/lua/mini/pick.lua#L1328>
function H.ast_grep(local_opts, opts)
  local tool = "ast-grep"
  local_opts = vim.tbl_extend("force", { pattern = nil, globs = {} }, local_opts or {})

  local globs = local_opts.globs or {}
  local name_suffix = #globs == 0 and "" or (" | " .. table.concat(globs, ", "))
  local show = H.get_config().source.show or H.show_with_icons
  local default_source = { name = string.format("Grep (%s%s)", tool, name_suffix), show = show }
  opts = vim.tbl_deep_extend("force", { source = default_source }, opts or {})

  local pattern = type(local_opts.pattern) == "string" and local_opts.pattern
    or vim.fn.input("Grep pattern: ")
  local command, postprocess = H.ast_grep_command(pattern, globs)
  return MiniPick.builtin.cli({ command = command, postprocess = postprocess }, opts)
end

---Grep live with ast-grep.
---@param local_opts? {tool:string,globs?:string[]}
-- NOTE: copi-pasted from <https://github.com/echasnovski/mini.nvim/blob/c122e852517adaf7257688e435369c050da113b1/lua/mini/pick.lua#L1364>
function H.ast_grep_live(local_opts, opts)
  local tool = "ast-grep"
  local_opts = vim.tbl_extend("force", { globs = {} }, local_opts or {})

  local globs = local_opts.globs or {}
  local name_suffix = #globs == 0 and "" or (" | " .. table.concat(globs, ", "))
  local default_source = {
    name = string.format("Grep live (%s%s)", tool, name_suffix),
    show = (H.get_config().source or {}).show or H.show_with_icons,
  }
  opts = vim.tbl_deep_extend("force", { source = default_source }, opts or {})

  local cwd = opts.source.cwd or vim.fn.getcwd()
  local set_items_opts = { do_match = false, querytick = MiniPick.get_querytick() }
  local spawn_opts = { cwd = cwd }
  local process
  local match = function(_, _, query)
    pcall(vim.loop.process_kill, process)
    local querytick = MiniPick.get_querytick()
    if querytick == set_items_opts.querytick then return end
    if #query == 0 then return MiniPick.set_picker_items({}, set_items_opts) end

    set_items_opts.querytick = querytick
    local command, postprocess = H.ast_grep_command(table.concat(query), globs)
    local cli_opts =
      { postprocess = postprocess, set_items_opts = set_items_opts, spawn_opts = spawn_opts }
    process = MiniPick.set_picker_items_from_cli(command, cli_opts)
  end

  opts = vim.tbl_deep_extend("force", opts or {}, { source = { items = {}, match = match } })
  return MiniPick.start(opts)
end

---@param pattern string
---@param globs string[]
-- TODO: contribute to mini.pick
function H.ast_grep_command(pattern, globs)
  local res =
    { "ast-grep", "run", "--color=never", "--context=0", "--json=stream", "--pattern", pattern }
  for _, g in ipairs(globs) do
    table.insert(res, "--globs")
    table.insert(res, g)
  end
  local postprocess = function(lines)
    local items = {}
    for _, line in ipairs(lines) do
      if line == "" then break end
      local raw = vim.json.decode(line)
      local item = {
        path = raw.file,
        lnum = raw.range.start.line + 1,
        col = raw.range.start.column + 1,
        lnum_end = raw.range["end"].line + 1,
        col_end = raw.range["end"].column + 1,
      }
      item.text = string.format("%s|%s|%s|%s", item.path, item.lnum, item.col, raw.lines)
      table.insert(items, item)
    end
    return items
  end
  return res, postprocess
end

return Pickers
