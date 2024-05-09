---@type LazySpec
return {
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    ft = { "markdown" },
    opts = {
      app = "browser",
    },
    init = function(...) require "plugins.peek.initialize"(...) end,
  },
}
