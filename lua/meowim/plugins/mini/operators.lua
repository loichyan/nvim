---@type MeoSpec
local Spec = { "mini.operators", event = "LazyFile" }

Spec.config = function()
  -- stylua: ignore
  require("mini.operators").setup({
    evaluate = { prefix = "g=" },
    exchange = { prefix = "gx" },
    multiply = { prefix = "gm" },
    replace  = { prefix = "gr" },
    sort     = { prefix = "gs" },
  })
end

return Spec
