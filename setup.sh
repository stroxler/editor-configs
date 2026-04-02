#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# Ensure a symlink exists at $2 pointing to $1.
# - No-op if the symlink already points to the right target.
# - Recreates if the link is dangling.
# - Fails if something else exists at that path.
ensure_symlink() {
    local target="$1"
    local link="$2"

    if [ -L "$link" ]; then
        local existing
        existing="$(readlink "$link")"
        # Normalize trailing slashes for comparison
        if [ "${existing%/}" = "${target%/}" ]; then
            echo "Symlink already exists: $link -> $target"
            return 0
        fi
        # Dangling or wrong target — check if it's dangling
        if [ ! -e "$link" ]; then
            echo "Replacing dangling symlink: $link -> $target"
            rm "$link"
            ln -s "$target" "$link"
        else
            echo "ERROR: $link already exists and points to $existing (expected $target)" >&2
            return 1
        fi
    elif [ -e "$link" ]; then
        echo "ERROR: $link already exists and is not a symlink" >&2
        return 1
    else
        echo "Creating symlink: $link -> $target"
        ln -s "$target" "$link"
    fi
}

# Chemacs2: emacs profile switcher
if [ -f "$HOME/.emacs.d/chemacs.el" ]; then
    echo "chemacs2 already installed at ~/.emacs.d"
elif [ -e "$HOME/.emacs.d" ]; then
    echo "ERROR: ~/.emacs.d exists but is not chemacs2 (missing chemacs.el)" >&2
    exit 1
else
    echo "Cloning chemacs2 into ~/.emacs.d"
    git clone https://github.com/plexus/chemacs2.git "$HOME/.emacs.d"
fi
ensure_symlink "$HOME/.emacs.d" "$HOME/.config/emacs"
ensure_symlink "$REPO_DIR/chemacs2-profiles.el" "$HOME/.emacs-profiles.el"

# Doom Emacs: clone and install base once, then cp -R for each variant.
# Each variant gets its own copy so that its .local package cache is independent.
DOOM_BASE="$HOME/.config/doomemacs"
if [ -d "$DOOM_BASE" ]; then
    echo "doomemacs base already cloned at $DOOM_BASE"
else
    echo "Cloning doomemacs into $DOOM_BASE"
    git clone --depth 1 https://github.com/doomemacs/doomemacs "$DOOM_BASE"
fi
if [ -d "$DOOM_BASE/.local" ]; then
    echo "doomemacs base already installed"
else
    echo "Running doom install for base packages..."
    "$DOOM_BASE/bin/doom" install
fi

# Create a doom variant by copying the base install.
# Usage: ensure_doom_variant <name>  (e.g. "a" creates doomemacs-a)
ensure_doom_variant() {
    local name="$1"
    local variant_dir="$HOME/.config/doomemacs-$name"
    if [ -d "$variant_dir" ]; then
        echo "doomemacs-$name already exists at $variant_dir"
    else
        echo "Copying doomemacs base to $variant_dir"
        cp -R "$DOOM_BASE" "$variant_dir"
    fi
    if [ -d "$variant_dir/.local" ]; then
        echo "doomemacs-$name already synced"
    else
        echo "Running doom sync for doom-$name..."
        DOOMDIR="$HOME/.config/doom-$name" "$variant_dir/bin/doom" sync --rebuild
    fi
}

ensure_doom_variant "a"

# Editor config symlinks into ~/.config/
ensure_symlink "$REPO_DIR/nvim-a" "$HOME/.config/nvim-a"
ensure_symlink "$REPO_DIR/nvim-b" "$HOME/.config/nvim-b"
ensure_symlink "$REPO_DIR/doom-a" "$HOME/.config/doom-a"
ensure_symlink "$REPO_DIR/runemacs" "$HOME/.config/runemacs"
