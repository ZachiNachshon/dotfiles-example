#!/bin/bash

# Title        macOS customized key-binding
# Description  Personalized custom key-binding
# Author       Zachi Nachshon <zachi.nachshon@gmail.com>
#==============================================================================

DOTFILES_REPO_LOCAL_PATH="$HOME/.config/dotfiles"

{
  if [[ -d "${HOME}/Library/KeyBindings" ]]; then
    mkdir -p "${HOME}/Library/KeyBindings"
  fi

  cp "${DOTFILES_REPO_LOCAL_PATH}/os/mac/assets/DefaultKeyBinding.dict" "${HOME}/Library/KeyBindings"
}
