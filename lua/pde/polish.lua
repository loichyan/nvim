local caddy = function()
  vim.bo.commentstring = "#%s"
  return "caddyfile"
end
vim.filetype.add {
  extension = {
    caddyfile = caddy,
    json = "jsonc",
  },
  filename = {
    Caddyfile = caddy,
    justfile = "just",
  },
}

local prev_paste = vim.paste
---@param lines string[]
---@diagnostic disable-next-line: duplicate-set-field
vim.paste = function(lines, ...)
  for i, line in ipairs(lines) do
    local _, _, s1, s2, hash, s4 = line:find "(https?://.+/)(%a+)(/%x+)(/.+)"
    if
      s2 == "blob" -- GitHub/GitLab
      or s2 == "commit" -- Gitea
      or s2 == "tree" -- sourcehut
    then
      lines[i] = s1 .. s2 .. hash:sub(1, 13) .. s4
    end
  end
  prev_paste(lines, ...)
end
