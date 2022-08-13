#!/bin/bash

# Title        macOS customized key-binding
# Description  Personalized custom key-binding
# Author       Zachi Nachshon <zachi.nachshon@gmail.com>
#==============================================================================

CONFIG_FOLDER_PATH="${HOME}/.config"
DOTFILES_REPO_LOCAL_PATH=${DOTFILES_REPO_LOCAL_PATH:-"${CONFIG_FOLDER_PATH}/dotfiles"}

{
  if [[ -d "${HOME}/Library/KeyBindings" ]]; then
    mkdir -p "${HOME}/Library/KeyBindings"
  fi

  cp "${DOTFILES_REPO_LOCAL_PATH}/os/mac/assets/DefaultKeyBinding.dict" "${HOME}/Library/KeyBindings"
}
