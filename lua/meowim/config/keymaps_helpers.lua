local H = {}
H.plugins = Meowim.plugins
H.utils = Meowim.utils

--------------------------------------------------------------------------------
--- COMMON KEYMAPS -------------------------------------------------------------
--------------------------------------------------------------------------------

H.clear_ui = function()
  require('quicker').close()
  require('mini.snippets').session.stop()
  vim.cmd('noh | redrawstatus')
end

---@param dir 'forward'|'backward'
---@param pair string
H.jump_pair = function(dir, pair)
  local left = pair:sub(1, 1)
  local right = pair:sub(2, 2)
  local flag = dir == 'backward' and 'bW' or 'W'
  vim.fn.searchpair('\\M' .. left, '', '\\M' .. right, flag)
end

---Copies uncommented and formatted text to clipboard.
H.smart_copy = function()
  return Meowim.utils.do_operator(function(lines)
    lines = vim.iter(lines):map(Meowim.utils.uncommentor()):totable()
    Meowim.utils.try_system(
      { 'prettierd', '--config-precedence=cli-override', '--prose-wrap=never', '.md' },
      { stdin = lines, text = true },
      vim.schedule_wrap(function(ok, out)
        if not ok then
          Meow.notifyf('WARN', 'failed to format yanked text: %s', out)
          out = table.concat(lines, '\n')
        end
        vim.fn.setreg('+', out)
      end)
    )
  end)
end

H.codediff = function(...)
  Meow.load('codediff.nvim')
  vim.cmd.CodeDiff(...)
end

---@param subcmd string
H.git = function(subcmd, arg1, ...)
  if subcmd == 'diff' then -- git diff <rev>
    local args = { ... }
    if args[#args] == '%' then
      return H.codediff('file', arg1)
    else
      return H.codediff(arg1)
    end
  elseif subcmd == 'show' and not string.match(arg1, ':%%$') then -- git show <rev>
    return H.codediff(arg1 .. '~1', arg1)
  elseif subcmd == 'show' then -- git show <rev>:%
    local rev = arg1:sub(1, #arg1 - 2)
    local path = vim.fn.expand('%:.') -- use relative path
    arg1 = vim.fn.fnameescape(rev .. ':' .. path) -- escape to avoid expansion errors
  end

  Meow.load('mini.git')
  vim.cmd.Git(subcmd, arg1, ...)
end

H.git_show_buffer = function()
  local rev
  if vim.v.count > 0 then
    rev = 'HEAD~' .. vim.v.count
  else
    rev = vim.fn.expand('<cword>')
    if not H.is_git_commit(rev) then
      rev = Meowim.utils.prompt('Show revision: ')
      if rev == '' then return end
    end
  end
  local cur = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniGitCommandSplit',
    once = true,
    command = string.format('call cursor(%d, %d) | normal! zz', cur[1], cur[2]),
  })
  H.git('show', rev .. ':%')
end

---@param mode 'edit'|'prompt'|'amend'
H.git_commit = function(mode)
  if mode == 'prompt' then
    local msg = Meowim.utils.prompt('Commit message: ')
    if msg == '' then return end
    msg = vim.fn.fnameescape(msg) -- escape to avoid expansion errors
    H.git('commit', '-m', msg)
  elseif mode == 'amend' then
    local msg = Meowim.utils.prompt('Edit message? (y/N) ', { mode = 'char' })
    msg = msg:lower()
    if msg == 'y' then
      H.git('commit', '--amend')
    elseif msg == 'n' or msg == '\r' then
      H.git('commit', '--amend', '--no-edit')
    end
  else
    H.git('commit')
  end
end

H.git_show_at_cursor = function()
  local rev = vim.fn.expand('<cword>')
  if H.is_git_commit(rev) then
    H.git('show', rev)
  else
    require('mini.git').show_at_cursor()
  end
end

H.pick_git_commits = function()
  local source = {
    choose = function(item)
      if type(item) ~= 'string' then return end
      H.git('show', item:match('^(%S+)'))
    end,
  }
  require('mini.extra').pickers.git_commits(nil, { source = source })
end

H.is_git_commit = function(str)
  return str ~= '' and string.find(str, '^%x%x%x%x%x%x%x+$') ~= nil and string.lower(str) == str
end

--------------------------------------------------------------------------------
--- DIAGNOSTICS ----------------------------------------------------------------
--------------------------------------------------------------------------------

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

---@param dir 'forward'|'backward'
---@param fallback string
H.jump_quickfix = function(dir, fallback)
  if require('quicker').is_open() then
    require('mini.bracketed').quickfix(dir)
  else
    fallback = vim.api.nvim_replace_termcodes(fallback, true, false, true)
    vim.api.nvim_feedkeys(fallback, 'n', false)
  end
end

---@param dir 'forward'|'backward'|'first'|'last'
---@param severity vim.diagnostic.Severity?
H.jump_diagnostic = function(dir, severity)
  require('mini.bracketed').diagnostic(dir, { float = false, severity = severity })
end

--------------------------------------------------------------------------------
--- PICKERS --------------------------------------------------------------------
--------------------------------------------------------------------------------

---@param picker string
H.pick = function(picker, local_opts)
  if picker == 'git_commits' then
    H.pick_git_commits()
  elseif picker == 'list' then
    require('quicker').close()
    require('mini.pick').registry.list({ scope = 'quickfix' })
  else
    require('mini.pick').registry[picker](local_opts)
  end
end

---@param scope 'current'|'all'
---@param severity vim.diagnostic.Severity?
H.pick_diagnostics = function(scope, severity)
  require('mini.pick').registry.diagnostic({
    scope = scope,
    get_opts = { severity = severity },
  })
end

---@param scope 'current'|'all'
H.pick_lgrep = function(scope, grep_opts)
  local globs = scope == 'current' and { vim.fn.expand('%') } or nil
  grep_opts = vim.tbl_extend('force', { globs = globs }, grep_opts or {})
  require('mini.pick').registry.grep_live(grep_opts)
end

---@param scope 'current'|'all'
H.pick_word = function(scope, grep_opts)
  local globs = scope == 'current' and { vim.fn.expand('%') } or nil
  local pattern = vim.fn.expand('<cword>')
  pattern = pattern ~= '' and pattern or Meowim.utils.prompt('Search word: ')

  local default_grep_opts = { pattern = pattern, globs = globs, tool = 'rg' }
  grep_opts = vim.tbl_extend('force', default_grep_opts, grep_opts or {})

  local name = string.format('Grep (%s | %s)', grep_opts.tool, pattern)
  local opts = { source = { name = name } }
  require('mini.pick').registry.grep(grep_opts, opts)
end

return H
