# Neovim Starter

## Source

This config is based the nvim-starter config at
[the 04-lsp-installer branch][https://github.com/VonHeikemen/nvim-starter/tree/04-lsp-installer]
of Heikemen's awesome `nvim-starter` project. It is a single-init-lua starter
that includes basic plugins with LSP support.

I've modified it to:
- set up `ocamllsp` as a language server. There are two ocaml language server options, this
  is the one you want and it corresponds to the `ocaml-lsp` opam / nix package, which provides
  the `ocaml-language-server` executable (yes, the inconsistent naming is a pain).
- install more color themes, and eliminate a few I don't like. In particular, even though
  I actually like the color palette in tokyonight (the default in `nvim-starter`) the actual syntax
  highlighting in OCaml is difficult for me to read.

## Introduction

Base configuration for Neovim. For those looking to make Neovim their new main editor. Here you'll find a popular combination of plugin to make your experience a little bit better.

A few things have been configured to resemble other modern text editors. You'll find a file explorer with tree style view, list open files in tabs, git integration and a terminal easy to toggle.

Autocompletion and "code intellisense" is provided by the LSP client built into Neovim. The following language servers are configured:

* ocaml

Most of the code in this configuration is explained in this series:

* [Build your first Neovim configuration in lua](https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/)
* [Neovim: Plugins to get started](https://vonheikemen.github.io/devlog/tools/neovim-plugins-to-get-started/)
* [Setup nvim-lspconfig + nvim-cmp](https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/)

## Requirements

* Neovim v0.8 or greater.
* git.
* A `C` compiler. Can be `gcc`, `tcc` or `zig`.
* [make](https://www.gnu.org/software/make/), the build tool.
* [tsserver](https://github.com/theia-ide/typescript-language-server). Typescript language server.
* [vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted). Provides language servers for `eslint`, `css` and `html`.
* [nodejs](https://nodejs.org/es/). Javascript runtime. Required by the language servers.
* (optional) [ripgrep](https://github.com/BurntSushi/ripgrep). Improves project wide search speed.
* (optional) [fd](https://github.com/sharkdp/fd). Improves file search speed.
* (optional) A patched font to display icons. I hear [nerdfonts](https://www.nerdfonts.com/) has a good collection.

> Here's the config [compatible with v0.7](https://github.com/VonHeikemen/nvim-starter/tree/112bbd38675d35d1c0dbf4e4c4dc750b836c8794). 

## Installation

* Backup your existing configuration if you have one.

* Create an `init.lua` file in your system. Use this command if you don't know the specific location of Neovim's configuration folder.

```sh
nvim --headless -c 'call mkdir(stdpath("config"), "p") | exe "edit" stdpath("config") . "/init.lua" | write | quit'
```

* Open your configuration file with Neovim.

```sh
nvim -c 'edit $MYVIMRC'
```

* Copy the content of `init.lua` in this repository into your own `init.lua`.

* Next time you start Neovim all plugins will be downloaded automatically. After plugins are downloaded restart Neovim.

### Plugins directory

Your plugins will be installed in a separate directory from your configuration. The location of this directory depends on your operating system and environment variables, so you'll need to execute this command to know where that is.

```sh
nvim --headless -c 'echo stdpath("data") . "/lazy/lazy.nvim" | quit'
```

## Keybindings

Leader key: `Space`.

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `<leader>h` | Go to first non empty character in line. |
| Normal | `<leader>l` | Go to last non empty character in line. |
| Normal | `<leader>a` | Select all text. |
| Normal | `gy` | Copy selected text to clipboard. |
| Normal | `gp` | Paste clipboard content. |
| Normal | `<leader>w` | Save file. |
| Normal | `<leader>bq` | Close current buffer. |
| Normal | `<leader>bc` | Close current buffer while preserving the window layout. |
| Normal | `<leader>bl` | Go to last active buffer. |
| Normal | `<leader>?` | Search oldfiles history. |
| Normal | `<leader><space>` | Search open buffers. |
| Normal | `<leader>ff` | Find file in current working directory. |
| Normal | `<leader>fg` | Search pattern in current working directory. Interactive "grep search". |
| Normal | `<leader>fd` | Search diagnostics in current file. |
| Normal | `<leader>fs` | Search pattern in current file. |
| Normal | `<leader>e` | Open file explorer. |
| Normal | `<Ctrl-g>` | Toggle the builtin terminal. |
| Normal | `K` | Displays hover information about the symbol under the cursor. |
| Normal | `gd` | Jump to the definition. |
| Normal | `gD` | Jump to declaration. |
| Normal | `gi` | Lists all the implementations for the symbol under the cursor. |
| Normal | `go` | Jumps to the definition of the type symbol |
| Normal | `gr` | Lists all the references. |
| Normal | `gs` | Displays a function's signature information. |
| Normal | `<F2>` | Renames all references to the symbol under the cursor. |
| Normal | `<F3>` | Format code in current buffer. |
| Normal | `<F4>` | Selects a code action available at the current cursor position. |
| Visual | `<F4>` | Selects a code action available in the selected text. |
| Normal | `gl` | Show diagnostics in a floating window. |
| Normal | `[d` | Move to the previous diagnostic. |
| Normal | `]d` | Move to the next diagnostic. |

### Autocomplete keybindings

| Mode | Key | Action |
| --- | --- | --- |
| Insert | `<Up>` | Move to previous item. |
| Insert | `<Down>` | Move to next item. |
| Insert | `<Ctrl-p>` | Move to previous item. |
| Insert | `<Ctrl-n>` | Move to next item. |
| Insert | `<Ctrl-u>` | Scroll up in documentation window. |
| Insert | `<Ctrl-d>` | Scroll down in documentation window. |
| Insert | `<Ctrl-e>` | Cancel completion. |
| Insert | `<C-y>` | Confirm completion. |
| Insert | `<Enter>` | Confirm completion. |
| Insert | `<Ctrl-f>` | Go to next placeholder in snippet. |
| Insert | `<Ctrl-b>` | Go to previous placeholder in snippet. |
| Insert | `<Tab>` | If completion menu is open, go to next item. Else, open completion menu. |
| Insert | `<Shift-Tab>` | If completion menu is open, go to previous item. |

## Plugin list

| Name | Description  |
| --- | --- |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager. |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | Collection of colorscheme for Neovim. |
| [onedark.vim](https://github.com/joshdick/onedark.vim) | Colorscheme based on Atom's default theme. |
| [monokai.nvim](https://github.com/tanvirtin/monokai.nvim) | Colorscheme based on Sublime text's default theme. |
| [darkplus.nvim](https://github.com/lunarvim/darkplus.nvim) | Colorscheme based on VS Code's default theme. |
| [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) | Helper functions to show icons. |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Pretty statusline. |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Pretty tabline. |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Shows indent guides in current file. |
| [nvim-tree.lua](https://github.com/kyazdani42/nvim-tree.lua) | File explorer. |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder. |
| [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | Extension for telescope. Allows fzf-like syntax in searches. |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Shows indicators in gutter based on file changes detected by git. |
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | Git integration into Neovim/Vim. |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Configures treesitter parsers. Provides modules to manipulate code. |
| [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | Creates textobjects based on treesitter queries. |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | Toggle comments. |
| [vim-surround](https://github.com/tpope/vim-surround) | Add, remove, change "surroundings". |
| [targets.vim](https://github.com/wellle/targets.vim) | Creates new textobjects. |
| [vim-repeat](https://github.com/tpope/vim-repeat) | Add "repeat" support for plugins. |
| [vim-bbye](https://github.com/moll/vim-bbye) | Close buffers without closing the current window. |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Collection of modules. Used internaly by other plugins. |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | Manage terminal windows easily. |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Quickstart configs for Neovim's LSP client.  |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Autocompletion engine. |
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) | nvim-cmp source. Suggest words in the current buffer. |
| [cmp-path](https://github.com/hrsh7th/cmp-path) | nvim-cmp source. Show suggestions based on file system paths. |
| [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip) | nvim-cmp source. Show suggestions based on installed snippets. |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | nvim-cmp source. Show suggestions based on LSP servers queries. |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine. |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | Collection of snippets. |

