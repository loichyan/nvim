---@type MeoSpec
local Spec = { "mini.keymap", event = "VeryLazy" }

Spec.config = function()
  local minikmap = require("mini.keymap")
  minikmap.setup()

  -- Integrate mini.pairs with mini.completion
  minikmap.map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
  minikmap.map_multistep("i", "<BS>", { "minipairs_bs" })

  -- Better escape
  minikmap.map_combo("i", "jk", "<BS><BS><Esc>")
  minikmap.map_combo("i", "jj", "<BS><BS><Esc>")
end

return Spec
