# Trox's Editor Configs

This is my repo for collecting alternative vim and emacs editor configurations.

## Why a collection of configurations?

I struggle a bit with editor configs. Since I began working at Meta, I use our
internal VSCode for most of my daily work, so I've gotten out of practice dealing with
vim and emacs. And the vim / emacs world has changed significantly with the widespread
adoption of LSP, so my older configs are not really sensible anymore.

Given this state of affairs, I want to make it easy to switch between configs, and in
particular have some very simple configs that are easy for me to read in one go when I
need to remember how things work as well as some bigger "starter-kit" based configs.

## What is here?

- `trox-nvim-starter`: My fork of the excelent `nvim-starter` repo: a very simple config
  but with basic LSP support wired up. This is a minimal usable config for ocaml.

## What do I hope to add?

- An nvim config based on zmre's nix-based vim starter
- A chemacs setup with several emacs configs:
  - An emacs-from-scratch config, probably following SystemCrafters again
  - Almost certainly a doom-emacs setup
  - Find someone who's done emacs via nix and see if I can make that work

## What is not here?

### Basic .vimrc

My basic .vimrc I use to have a minimally usable editor on foreign machines.
I should probably write it down somewhere eventually.

### `pwnvim`

I cloned `zmre`'s `pwnvim` into `~/devtool-flakes/pwnvim/` with this snippet:
```
mkdir -p ~/devtool-flakes
git clone git@github.com:zmre/pwnvim.git ~/devtool-flakes/pwnvim
pushd ~/devtool-flakes/pwnvim
  nix build .
popd
```
which allows me to edit files using that config easily. I currently am using this
as my editor for nix files because the nix lsp config here is very good, e.g.
```
~/devtool-flakes/pwnvim/result/bin/nvim flake.nix
```
