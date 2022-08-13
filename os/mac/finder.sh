#!/bin/bash

# Title        macOS Finder preferences
# Description  Personlaize Finder options
# Author       Zachi Nachshon <zachi.nachshon@gmail.com>
#==============================================================================

{
  # Show hidden files by default
  defaults write com.apple.finder AppleShowAllFiles -bool true

  # Show all filename extensions
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  # Show status bar
  defaults write com.apple.finder ShowStatusBar -bool true

  # Show path bar
  defaults write com.apple.finder ShowPathbar -bool true
}
