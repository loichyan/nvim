---@type MeoSpec
return {
  "folke/ts-comments.nvim",
  event = "LazyFile",
  config = function()
    require("ts-comments").setup({
      lang = {
        rust = {
          "// %s",
          "/* %s */",
          doc_comment = "/// %s",
        },
      },
    })
  end,
}
