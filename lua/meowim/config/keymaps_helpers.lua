----------------------
--- COMMON KEYMAPS ---
----------------------

local H = {}

H.plugins = Meowim.plugins
H.utils = Meowim.utils

function H.clear_ui()
  vim.cmd("noh")
  require("quicker").close()
  require("mini.snippets").session.stop()
end

---Copies uncomment text to clipboard.
---@param mode? "visual"
---@param opts? {join:boolean}
function H.smart_copy(mode, opts)
  return Meowim.utils.do_operator(mode, function(lines)
    local iter, text = vim.iter(lines):map(Meowim.utils.uncommentor())
    if (opts or {}).join then
      text = iter
        :map(function(l) return vim.trim(l) end)
        :filter(function(l) return l ~= "" end)
        :join(" ")
    else
      text = iter:join("\n")
    end

    vim.fn.setreg("+", text)
  end)
end

function H.gitexec(...)
  Meow.load("mini.git")
  vim.cmd.Git(...)
end

-----------------------------
--- PICKERS & DIAGNOSTICS ---
-----------------------------

---@param dir "forward"|"backward"
---@param fallback string
function H.jump_quickfix(dir, fallback)
  if require("quicker").is_open() then
    require("mini.bracketed").quickfix(dir)
  else
    fallback = vim.api.nvim_replace_termcodes(fallback, true, false, true)
    vim.api.nvim_feedkeys(fallback, "n", false)
  end
end

---@param dir "forward"|"backward"|"first"|"last"
---@param severity vim.diagnostic.Severity?
function H.jump_diagnostic(dir, severity)
  require("mini.bracketed").diagnostic(dir, { severity = severity })
end

---@param picker string
---@param opts? table
function H.pick(picker, opts) require("mini.pick").registry[picker](opts) end

function H.pick_quickfix()
  require("quicker").close()
  require("mini.pick").registry.list({ scope = "quickfix" })
end

---@param scope "current"|"all"
---@param severity vim.diagnostic.Severity?
function H.pick_diagnostics(scope, severity)
  require("mini.pick").registry.diagnostic({
    scope = scope,
    get_opts = { severity = severity },
  })
end

---@param scope "current"|"all"
---@param tool? "rg"|"git"|"ast-grep"
function H.pick_lgrep(scope, tool)
  local globs = scope == "current" and { vim.fn.expand("%") } or nil
  if tool == "ast-grep" then
    require("mini.pick").registry.ast_grep_live({ globs = globs })
  else
    require("mini.pick").registry.grep_live({ tool = tool, globs = globs })
  end
end

---@param scope "current"|"all"
---@param tool? "rg"|"git"|"ast-grep"
function H.pick_word(scope, tool)
  local globs = scope == "current" and { vim.fn.expand("%") } or nil
  local pattern = vim.fn.expand("<cword>")
  if tool == "ast-grep" then
    require("mini.pick").registry.ast_grep({ pattern = pattern, globs = globs })
  else
    require("mini.pick").registry.grep({ tool = tool, pattern = pattern, globs = globs })
  end
end

-------------------
--- LSP KEYMAPS ---
-------------------

---@param scope "current"|"all"
function H.lsp_implementation(scope)
  vim.lsp.buf.implementation({
    on_list = scope == "current" and Meowim.utils.loclist_buf or nil,
  })
end

---@param scope "current"|"all"
function H.lsp_references(scope)
  vim.lsp.buf.references({ includeDeclaration = false }, {
    on_list = scope == "current" and Meowim.utils.loclist_buf or nil,
  })
end

function H.lsp_definition()
  vim.lsp.buf.definition({
    on_list = Meowim.utils.loclist_unique,
  })
end

function H.lsp_type_definition()
  vim.lsp.buf.type_definition({
    on_list = Meowim.utils.loclist_unique,
  })
end

return H
