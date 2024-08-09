local is_rust_analyzer = function(client) return client.name == "rust-analyzer" end

return {
  { cond = "rustaceanvim" },

  expand_macro = { "<Cmd>RustLsp expandMacro<CR>", desc = "Expand macro", cond = is_rust_analyzer },
  open_cargo = { "<Cmd>RustLsp openCargo<CR>", desc = "Open Cargo.toml", cond = is_rust_analyzer },
}
