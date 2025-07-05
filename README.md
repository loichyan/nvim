# 😺 Meowim

Meowim is a [mini.nvim](https://github.com/echasnovski/mini.nvim) powered launch point for your
personal development environment.

## ✨ Features

- 🔋 20+ pre-configured mini modules
- 🪄 A clean UI with a smooth theme
- ⌨️ Sensible default keymaps
- ⚡ Lazy-loading of most plugins
- 💤 Plugin management in the [lazy](https://github.com/folke/lazy.nvim) way

## 📋 Requirements

- the [latest stable Neovim](https://github.com/neovim/neovim/releases/latest)
- Git
- a C compiler for nvim-treesitter (see
  [here](https://github.com/nvim-treesitter/nvim-treesitter#requirements))
- [ripgrep](https://github.com/BurntSushi/ripgrep) (*required by mini.pick*)
- a [NerdFont](https://www.nerdfonts.com/) (v3.0 or greater) (*optional but highly recommended*)

## 🚗 Quick start

[Fork](https://github.com/loichyan/Meowim/fork) this repo so that you have your own copy that you
can modify, then install by:

```sh
# 1) Make a backup of any existing configurations
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim
# 2) Clone your fork
git clone https://github.com/<your_id>/Meowim ~/.config/nvim
```

Additionally, you can check out my own fork for inspiration.

## ♥️ Special Thanks

- [mini.nvim](https://github.com/echasnovski/mini.nvim) for its significant contribution to the
  birth of this project.
- [LazyVim](https://github.com/LazyVim/LazyVim) for providing many excellent configuration snippets
  used in this project.

## ⚖️ License

Licensed under GNU General Public License, Version 3.0 ([LICENSE](LICENSE) or
<https://www.gnu.org/licenses/gpl-3.0>).
