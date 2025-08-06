---@type MeoSpec
return {
  "mini.notify",
  lazy = false,
  priority = 95,
  config = function()
    local mininotify = require("mini.notify")
    mininotify.setup()
    vim.notify = mininotify.make_notify()
  end,
}
