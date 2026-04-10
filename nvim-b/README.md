# Tiny Neovim Config

This neovim config assumes you have version 0.11+ (we are using the built-in
LSP configuration) and you want to use lazy.nvim to manage plugins (although
we have almost no plugins right now - only a color theme!)

You can try it out with
```
cd ~/.config
git clone <this repo> trox-simple-nvim
NVIM_APPNAME=trox-simple-nvim nvim <some_file>
```

When you do this, note the following:
- `init.lua` is always run be vim, and `lua/` is the search root for later `require` calls
- Understanding the behavior of `lazy.vim` is key:
  - it's *existence* is configured as directed by the docs in `lua/config/lazy.lua`
  - it will use pagages declared in `lua/plugins/init.lua`
  - the data directory will be `~/.local/share/trox-simple-nvim/lazy/`

## Inspration

Thanks to Heiker Curiel for the `nvim-starter` repository, which I've found to be
a very valuable reference for how to do simple vim configurations.

Thanks to the Primagean for [his demo video](https://www.youtube.com/watch?v=w7i4amO_zaE),
which got me started on this although I diverged pretty quickly when I realized that
(a) I wanted to use lazy.nvim to manage packages and (b) I wanted to use the built-in
LSP functionality, which didn't exist at the time of that video.
