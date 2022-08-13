#!/bin/bash

# Title        oh-my-zsh installation
# Description  Install oh-my-zsh framework for managing ZSH configurations
# Author       Zachi Nachshon <zachi.nachshon@gmail.com>
#==============================================================================

{
  if [[ "$(basename "$SHELL")" != "zsh" ]]; then
    echo -e "Skipping oh-my-zsh installation, shell is not zsh."
    return
  fi

  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo -e "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # wget -O /tmp/install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
    # # --unattended: installer will not change the default shell or run zsh after the install
    # sh /tmp/install.sh --unattended
  else
    echo -e "Skipping oh-my-zsh installation, already installed."
  fi 
}
