local Colors = {}
local H = {}

H.palette = nil -- palette to generate highlight groups
H.defined_higroups = {} -- already generated higroups

Colors.update = function(palette)
  local hl = function(name) return H.get_hl(0, { name = name, create = false }) end

  -- stylua: ignore
  local defaults = {
    ['text']     = hl('StatusLine').fg,
    ['text2']    = hl('StatusLineNC').fg,
    ['overlay']  = hl('CursorLine').bg,

    ['white']    = hl('Normal').fg,
    ['red']      = hl('Identifier').fg,
    ['orange']   = hl('Constant').fg,
    ['yellow']   = hl('Type').fg,
    ['green']    = hl('String').fg,
    ['cyan']     = hl('Special').fg,
    ['blue']     = hl('Function').fg,
    ['magenta']  = hl('Keyword').fg,
  }

  H.palette = vim.tbl_extend('force', defaults, palette or {})
  H.defined_higroups = {}
end

Colors.get_hl = function(name)
  if not Colors.higroups[name] then return name end
  if not H.defined_higroups[name] then
    local hiname = 'Meoline_' .. name
    local opts = vim.deepcopy(Colors.higroups[name] or {})
    opts.fg = opts.fg and H.palette[opts.fg] or 'NONE'
    opts.bg = opts.bg and H.palette[opts.bg] or 'NONE'
    opts.force = true
    H.set_hl(0, hiname, opts)
    H.defined_higroups[name] = hiname
  end
  return H.defined_higroups[name]
end

-- stylua: ignore
Colors.higroups = {
  -- statusline
  ['mode_normal']     = {fg='white'},
  ['mode_visual']     = {fg='yellow'},
  ['mode_insert']     = {fg='green'},
  ['mode_replace']    = {fg='magenta'},
  ['mode_command']    = {fg='red'},
  ['mode_other']      = {fg='overlay'},

  ['stl_workspace']   = {fg='orange',bold=true},
  ['stl_gitinfo']     = {fg='orange'},
  ['stl_filename']    = {fg='text'},
  ['stl_fileinfo']    = {fg='text'},

  ['stl_showcmd']     = {fg='text'},
  ['stl_searchcount'] = {fg='green'},
  ['stl_recording']   = {fg='blue'},
  ['stl_bufinfo']     = {fg='text'},
  ['stl_location']    = {fg='yellow'},

  -- tabline
  ['tbl_active']      = {fg='yellow',bold=true},
  ['tbl_visible']     = {fg='white'},
  ['tbl_hidden']      = {fg='text'},

  ['tbl_activeinfo']  = {fg='yellow'},
  ['tbl_visibleinfo'] = {fg='white'},
  ['tbl_hiddeninfo']  = {fg='text'},

  ['tbl_activepage']  = {fg='overlay',bg='orange',bold=true},
  ['tbl_hiddenpage']  = {fg='text',bg='overlay'},

  ['tbl_trunc']       = {fg='yellow'},

  -- winbar
  ['wbr_active']  = {fg='white'},
  ['wbr_visible'] = {fg='text'},
  ['wbr_hidden']  = {fg='text2'},

  ['wbr_separator']   = {fg='text'},
  ['wbr_trunc']       = {fg='text'},
}

-- stylua: ignore
Colors.mode_higroups = {
  -- normal
  ['n']   = 'mode_normal',
  -- visual
  ['v']   = 'mode_visual',
  ['V']   = 'mode_visual',
  ['\22'] = 'mode_visual',
  ['s']   = 'mode_visual',
  ['S']   = 'mode_visual',
  ['\19'] = 'mode_visual',
  -- insert
  ['i']   = 'mode_insert',
  -- replace
  ['R']   = 'mode_replace',
  -- command
  ['c']   = 'mode_command',
  -- other
  ['r']   = 'mode_other',
  ['!']   = 'mode_other',
  ['t']   = 'mode_other',
}

-- stylua: ignore
Colors.diagnostic_sections = {
  { vim.diagnostic.severity.ERROR, icon = 'E', hl = 'DiagnosticError' },
  { vim.diagnostic.severity.WARN,  icon = 'W', hl = 'DiagnosticWarn'  },
  { vim.diagnostic.severity.INFO,  icon = 'I', hl = 'DiagnosticInfo'  },
  { vim.diagnostic.severity.HINT,  icon = 'H', hl = 'DiagnosticHint'  },
}

-- stylua: ignore
Colors.diff_sections = {
  { 'add',    icon = '+', hl = 'diffAdded'   },
  { 'change', icon = '~', hl = 'diffChanged' },
  { 'delete', icon = '-', hl = 'diffRemoved' },
}

H.get_hl = vim.api.nvim_get_hl
H.set_hl = vim.api.nvim_set_hl

return Colors
