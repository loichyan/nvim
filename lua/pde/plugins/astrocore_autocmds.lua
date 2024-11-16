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
            if vim.bo.filetype == "gitcommit" then
              o.textwidth = 72
              o.colorcolumn = { 72 }
            elseif vim.bo.buflisted then
              o.textwidth = 80
              o.colorcolumn = { 80 }
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
