---@type MeoSpec
local Spec = { "folke/ts-comments.nvim", event = "LazyFile" }

Spec.config = function()
  require("ts-comments").setup({
    lang = {
      rust = {
        "// %s",
        "/* %s */",
        doc_comment = "/// %s",
      },
    },
  })
end

return Spec
