----------------------
--- COMMON KEYMAPS ---
----------------------

local H = {}

H.plugins = Meowim.plugins
H.utils = Meowim.utils

H.clear_ui = function()
  vim.cmd("noh")
  require("quicker").close()
  require("mini.snippets").session.stop()
end

---Copies uncommented and formatted text to clipboard.
H.smart_copy = function()
  return Meowim.utils.do_operator(function(lines)
    lines = vim.iter(lines):map(Meowim.utils.uncommentor()):totable()
    Meowim.utils.try_system(
      { "prettierd", "--config-precedence=cli-override", "--prose-wrap=never", ".md" },
      { stdin = lines, text = true },
      vim.schedule_wrap(function(ok, out)
        if not ok then
          Meow.notifyf("WARN", "failed to format yanked text: %s", out)
          out = table.concat(lines, "\n")
        end
        vim.fn.setreg("+", out)
      end)
    )
  end)
end

---@param subcmd string
H.git = function(subcmd, ...)
  if subcmd == "diff" or subcmd == "log" then
    vim.cmd.Gitraw(subcmd, ...)
  else
    Meow.load("mini.git")
    vim.cmd.Git(subcmd, ...)
  end
end

H.git_show_buffer = function()
  local rev
  if vim.v.count > 0 then
    rev = "HEAD~" .. vim.v.count
  else
    rev = vim.fn.expand("<cword>")
    if not H.is_git_commit(rev) then
      rev = Meowim.utils.prompt("Show revision: ")
      if rev == "" then return end
      rev = vim.fn.fnameescape(rev) -- escape to avoid expansion errors
    end
  end
  H.git("show", rev .. ":%")
end

---@param mode "prompt"|"edit"|"amend"
H.git_commit = function(mode)
  if mode == "edit" then
    H.git("commit")
  elseif mode == "amend" then
    local msg = Meowim.utils.prompt("Edit message? (y/N) ", { mode = "char" })
    msg = msg:lower()
    if msg == "y" then
      H.git("commit", "--amend")
    elseif msg == "n" or msg == "\r" then
      H.git("commit", "--amend", "--no-edit")
    end
  else
    local msg = Meowim.utils.prompt("Commit message: ")
    if msg == "" then return end
    msg = vim.fn.fnameescape(msg) -- escape to avoid expansion errors
    H.git("commit", "-m", msg)
  end
end

H.git_show_at_cursor = function()
  local rev = vim.fn.expand("<cword>")
  if H.is_git_commit(rev) then
    vim.cmd.Gitraw("show", rev)
  else
    require("mini.git").show_at_cursor()
  end
end

H.pick_commits = function()
  local source = {
    preview = function(bufnr, item)
      if type(item) ~= "string" then return end
      Meowim.utils.show_term_output(bufnr, { "gitraw", "show", item:match("^(%S+)") })
    end,
    choose = function(item)
      if type(item) ~= "string" then return end
      vim.cmd.Gitraw("show", item:match("^(%S+)"))
    end,
  }
  require("mini.extra").pickers.git_commits(nil, { source = source })
end

H.is_git_commit = function(str)
  return str ~= "" and string.find(str, "^%x%x%x%x%x%x%x+$") ~= nil and string.lower(str) == str
end

-----------------------------
--- PICKERS & DIAGNOSTICS ---
-----------------------------

local last_virtualtext
H.toggle_virtual_text = function()
  local current = vim.diagnostic.config() or {}
  if current.virtual_lines then
    vim.diagnostic.config({
      virtual_text = last_virtualtext or current.virtual_text,
      virtual_lines = false,
    })
  else
    last_virtualtext = current.virtual_text
    vim.diagnostic.config({
      virtual_text = { current_line = false },
      virtual_lines = { current_line = true },
    })
  end
end

---@param dir "forward"|"backward"
---@param fallback string
H.jump_quickfix = function(dir, fallback)
  if require("quicker").is_open() then
    require("mini.bracketed").quickfix(dir)
  else
    fallback = vim.api.nvim_replace_termcodes(fallback, true, false, true)
    vim.api.nvim_feedkeys(fallback, "n", false)
  end
end

---@param dir "forward"|"backward"|"first"|"last"
---@param severity vim.diagnostic.SeverityName?
H.jump_diagnostic = function(dir, severity)
  require("mini.bracketed").diagnostic(dir, { float = false, severity = severity })
end

---@param picker string
H.pick = function(picker, local_opts) require("mini.pick").registry[picker](local_opts) end

H.pick_quickfix = function()
  require("quicker").close()
  require("mini.pick").registry.list({ scope = "quickfix" })
end

---@param scope "current"|"all"
---@param severity vim.diagnostic.SeverityName?
H.pick_diagnostics = function(scope, severity)
  require("mini.pick").registry.diagnostic({
    scope = scope,
    get_opts = { severity = severity },
  })
end

---@param scope "current"|"all"
H.pick_lgrep = function(scope, grep_opts)
  local globs = scope == "current" and { vim.fn.expand("%") } or nil
  grep_opts = vim.tbl_extend("force", { globs = globs }, grep_opts or {})
  require("mini.pick").registry.grep_live(grep_opts)
end

---@param scope "current"|"all"
H.pick_word = function(scope, grep_opts)
  local globs = scope == "current" and { vim.fn.expand("%") } or nil
  local pattern = vim.fn.expand("<cword>")
  pattern = pattern ~= "" and pattern or Meowim.utils.prompt("Search word: ")

  local default_grep_opts = { pattern = pattern, globs = globs, tool = "rg" }
  grep_opts = vim.tbl_extend("force", default_grep_opts, grep_opts or {})

  local name = string.format("Grep (%s | %s)", grep_opts.tool, pattern)
  local opts = { source = { name = name } }
  require("mini.pick").registry.grep(grep_opts, opts)
end

-------------------
--- LSP KEYMAPS ---
-------------------

---@param scope "current"|"all"
H.lsp_implementation = function(scope)
  vim.lsp.buf.implementation({
    on_list = scope == "current" and Meowim.utils.loclist_buf or nil,
  })
end

---@param scope "current"|"all"
H.lsp_references = function(scope)
  vim.lsp.buf.references({ includeDeclaration = false }, {
    on_list = scope == "current" and Meowim.utils.loclist_buf or nil,
  })
end

H.lsp_definition = function()
  vim.lsp.buf.definition({
    on_list = Meowim.utils.loclist_unique,
  })
end

H.lsp_type_definition = function()
  vim.lsp.buf.type_definition({
    on_list = Meowim.utils.loclist_unique,
  })
end

return H
