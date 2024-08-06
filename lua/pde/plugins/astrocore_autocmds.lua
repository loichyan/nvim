---@type LazyPluginSpec
return {
  "astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    require("deltavim.utils").merge(opts.autocmds, {
      ruler = {
        {
          event = "FileType",
          callback = function()
            local o = vim.opt_local
            ---@diagnostic disable-next-line: undefined-field
            if o.buflisted:get() == true then
              o.textwidth = 100
              o.colorcolumn = { 100 }
            end
          end,
        },
      },
      polish = {
        {
          event = "VimEnter",
          callback = function() require "pde.polish" end,
        },
      },
    })
  end,
}
