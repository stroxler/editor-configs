# Trox's Editor Configs

This is my repo for collecting alternative vim and emacs editor configurations.

## Why a collection of configurations?

I've historically struggled a bit with editor configs. They take work to maintain
and rot over time, plus since working at Meta I'm often boxed into useing the


## What about my editor config *isn't* here


### Basic `.vimrc`

I have a copy of a basic `.vimrc` suitable for machines that only have the
original `vim` (although neovim can use it too) in my `ape-nix` repo, becasue
I consider it part of a bare minumum setup.


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

### `chemacs2`

I use a multi-config emacs as follows:
```
# Make chemacs2 the "true" emacs config
git clone git@github.com:plexus/chemacs2.git ~/.config/emacs

# Point emacs by default at the runemacs in this repo (assumed to live at ~/kode/editor-configs)
echo '
(("default" . ((user-emacs-directory . "~/kode/editor-configs/runemacs.d"))))
' > ~/.emacs-profiles.d
```

## What is here?

### The `older` directory

This contains some configs I consider stale - many of them won't work properly,
for example `trox-nvim-starter` doesn't work on a fresh install with no lazy.lock
because `nvim-treesitter` made breaking internal changes - but might be useful
to reference back to going forward.

I expect this directory to grow over time, because emacs and vim are both prone
to needing periodic "config resets" and it's useful to have the older configs
to refer back to.

### `runemacs`

This is my emacs config from following along with the System Crafter's
"emacs from scratch" series from 2020, or sometime around then. It's a pretty
basic emacs setup, but has all the minimal features a good editor should have.

### `nvim-a`

This is my first stab in 2026-03 at a simple agent-oriented neovim. I started off
using something very close to `older/trox-nvim-starter`, but had to fix multiple
issues

As of writing (in 2026-03) this is both in a working state and also both not well
organized and not well thought-out in terms of ergonomics.

But what it has is a pretty basic neovim - which could easily be extended - and
simple agent integration using the `claude-code` plugin, which is centered around
CLI interaction (and therefore works not only with `claude` but also with `codex`
and other CLI agents).

## What do I hope to add?

- An nvim config based on zmre's nix-based vim starter
- A chemacs setup with several emacs configs:
  - An emacs-from-scratch config, probably following SystemCrafters again
  - Almost certainly a doom-emacs setup
  - Find someone who's done emacs via nix and see if I can make that work
