#!/bin/bash

# echo on
set -x

if [ ! -d "$HOME"/.dotfiles ]; then
    git clone --bare git@github.com:ubiuser/dotfiles.git "$HOME"/.dotfiles
fi
function dotfiles {
    git --git-dir="$HOME"/.dotfiles --work-tree="$HOME" "$@"
}
if [ ! -d "$HOME"/.dotfiles-backups ]; then
    mkdir -p "$HOME"/.dotfiles-backups
fi
DOTFILES_BACKUP=$(mktemp -d -p "$HOME"/.dotfiles-backups)
dotfiles config core.sparseCheckout true
dotfiles sparse-checkout set --no-cone '/*' 'install.sh' '!LICENSE' '!README.md'
dotfiles checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} mv {} "$DOTFILES_BACKUP"/{} && echo "existing dotfiles saved in $DOTFILES_BACKUP"
dotfiles reset --hard HEAD
dotfiles config status.showUntrackedFiles no
