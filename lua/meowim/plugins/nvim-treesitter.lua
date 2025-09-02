---@type MeoSpec
local Spec = {
  "nvim-treesitter/nvim-treesitter",
  checkout = "main",
  build = function() vim.cmd("TSUpdate") end,
  lazy = false,
}
local H = {}

Spec.config = function()
  -- See <https://github.com/neovim/neovim/issues/32660>
  vim.g._ts_force_sync_parsing = true
  require("nvim-treesitter").setup()

  Meow.autocmd("meowim.plugins.nvim-treesitter", {
    {
      event = "User",
      pattern = "VeryLazy",
      desc = "Ensure some parsers are installed",
      once = true,
      callback = vim.schedule_wrap(H.ensure_installed),
    },
    {
      event = "FileType",
      desc = "Auto install parsers",
      callback = H.setup_parser,
    },
  })
end

function H.ensure_installed()
  local ensure_installed = {
    "bash",
    "c",
    "css",
    "diff",
    "gitcommit",
    "html",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "query",
    "vim",
    "vimdoc",
  }
  require("nvim-treesitter").install(ensure_installed):await(H.update_installed)
end

function H.setup_parser(ev)
  if ev.match == "dockerfile" then return end -- parser for dockerfile is too buggy

  local parser = vim.treesitter.language.get_lang(ev.match)
  if not H.is_available(parser) then return end

  local bufnr, winnr = vim.api.nvim_get_current_buf(), vim.api.nvim_get_current_win()
  H.with_parser(parser, function()
    vim.treesitter.start(bufnr)
    vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

    vim.wo[winnr].foldlevel = 99
    vim.wo[winnr].foldmethod = "expr"
    vim.wo[winnr].foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end)
end

function H.with_parser(parser, callback)
  if not H.installed then H.update_installed() end

  if H.installed[parser] == nil then
    require("nvim-treesitter").install(parser):await(function(err)
      if err then
        H.installed[parser] = false
        Meow.notifyf("ERROR", "failed to install parser '%s': %s", parser, err)
      else
        H.installed[parser] = true
        pcall(callback) -- ignore errors when window/buffer gets invalid
      end
    end)
  elseif H.installed[parser] then
    callback()
  end
end

function H.update_installed()
  H.installed = H.installed or {}
  for _, p in ipairs(require("nvim-treesitter.config").get_installed("parsers")) do
    H.installed[p] = true
  end
end

function H.is_available(parser)
  if not H.available then
    H.available = {}
    for _, p in ipairs(require("nvim-treesitter.config").get_available()) do
      H.available[p] = true
    end
  end
  return H.available[parser]
end

return Spec
