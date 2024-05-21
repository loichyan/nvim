return {
  "astrolsp",
  opts = function(_, opts)
    require("deltavim.utils").make_mappings(opts.mappings, {
      n = {
        ["<Leader>lm"] = "rustaceanvim.expand_macro",
        ["<Leader>lo"] = "rustaceanvim.open_cargo",
      },
    })
  end,
}
