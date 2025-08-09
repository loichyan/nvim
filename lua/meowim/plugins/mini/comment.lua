---@type MeoSpec
return {
  "mini.comment",
  event = "LazyFile",
  config = function()
    require("mini.comment").setup({
      -- stylua: ignore
      mappings = {
        comment        = 'gc',
        comment_line   = 'gcc',
        comment_visual = 'gc',
        textobject     = 'gc',
      },
    })
  end,
}
