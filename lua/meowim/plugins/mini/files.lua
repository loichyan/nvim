---@type MeoSpec
return {
  "mini.files",
  event = "VeryLazy",
  config = function()
    require("mini.files").setup({
      options = { use_as_default_explorer = true },
    })
    Meow.autocmd("meowim.plugins.mini.files", {
      {
        event = "FileType",
        pattern = "minifiles",
        desc = "Improve motions in the explorer",
        command = "setlocal iskeyword-=_",
      },
    })
  end,
}
