#!/bin/bash

# Title        macOS keyboard settings
# Description  Keyboard custom settings
# Author       Zachi Nachshon <zachi.nachshon@gmail.com>
#==============================================================================

{
  # Disable press-and-hold for keys in favor of key repeat
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

  # Set a blazingly fast keyboard repeat rate
  defaults write NSGlobalDomain KeyRepeat -int 1
  defaults write NSGlobalDomain InitialKeyRepeat -int 10
}
