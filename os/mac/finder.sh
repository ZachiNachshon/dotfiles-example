#!/bin/bash

# Title        macOS Finder preferences
# Description  Personlaize Finder options
# Author       Zachi Nachshon <zachi.nachshon@gmail.com>
#==============================================================================

{
  echo "test"
  # ### Finder: show hidden files by default
  # defaults write com.apple.finder AppleShowAllFiles -bool true

  # ### Finder: show all filename extensions
  # defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  # ### Finder: show status bar
  # defaults write com.apple.finder ShowStatusBar -bool true

  # ### Finder: show path bar
  # defaults write com.apple.finder ShowPathbar -bool true
}
