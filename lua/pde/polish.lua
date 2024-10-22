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
