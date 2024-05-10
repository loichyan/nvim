return function(_, opts)
  require("deltavim.utils").deep_merge(require("leap").opts, opts)
  require("leap.user").set_repeat_keys("<enter>", "<backspace>")

  local map = vim.keymap.set
  map({ "n", "x", "o" }, "s", "<Plug>(leap-forward-to)")
  map({ "n", "x", "o" }, "S", "<Plug>(leap-backward-to)")
  map({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
end
