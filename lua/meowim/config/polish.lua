-- Other configurations that may slow down the startup.

-- Force to use JSONC instead of bare JSON.
vim.filetype.add({
  extension = { json = "jsonc" },
})

-- Enable virtual text
vim.diagnostic.config({ virtual_text = true })

-- Register some useful commands

---Pipes command output to a scratch buffer.
vim.api.nvim_create_user_command("Cat", function(ctx)
  local res = vim.api.nvim_exec2(ctx.args, { output = true })

  local mods = ctx.mods or "tab"
  vim.cmd(mods .. " split")
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].filetype = "nofile"

  local lines = vim.split(res.output, "\n", { plain = true })
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_win_set_buf(0, bufnr)
end, { nargs = "+", complete = "command" })

---Pipes raw output of git command to a scratch buffer.
vim.api.nvim_create_user_command("Gitraw", function(ctx)
  local mods = ctx.mods ~= "" and ctx.mods or "tab"
  local args = vim.tbl_map(vim.fn.expandcmd, ctx.fargs)
  -- `gitraw` does two things:
  -- 1. Disables paging of the delta pager.
  -- 2. Adds a short sleep after git exits to resolve <https://github.com/neovim/neovim/issues/3030>.
  -- So it eventually looks like this:
  -- ```sh
  -- git -c 'core.pager=delta --paging=never' "$@" && sleep 0.1
  -- ```
  Meowim.utils.show_term_output(
    nil,
    { "gitraw", unpack(args) },
    { on_exit = function() vim.cmd(mods .. " split") end }
  )
end, { nargs = "+" })

require("meowim.config.polish_cmdheight")
