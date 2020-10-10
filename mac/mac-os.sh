#!/bin/bash

# Title        mac-os.sh
# Description  Customize macOS default settings and change key bindings
# Author       Zachi Nachshon <zachi.nachshon@gmail.com>
#==============================================================================
print_banner() {
  echo -e "
███╗   ███╗ █████╗  ██████╗               ██████╗ ███████╗
████╗ ████║██╔══██╗██╔════╝              ██╔═══██╗██╔════╝
██╔████╔██║███████║██║         █████╗    ██║   ██║███████╗
██║╚██╔╝██║██╔══██║██║         ╚════╝    ██║   ██║╚════██║
██║ ╚═╝ ██║██║  ██║╚██████╗              ╚██████╔╝███████║
╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝               ╚═════╝ ╚══════╝
"
}

key_bindings() {
  if [[ ! -d "${HOME}/Library/KeyBindings" ]]; then
    mkdir -p ${HOME}/Library/KeyBindings
    cp mac/assets/DefaultKeyBinding.dict ${HOME}/Library/KeyBindings
    echo -e "\nKey bindings override..."
    echo -e "Key bindings override... Done."
  else
    echo -e "\nKey bindings override..."
    echo -e "Key bindings override... Already installed."
  fi
}

finder() {
  echo -e "\nFinder settings override..."

  ### Finder: show hidden files by default
  defaults write com.apple.finder AppleShowAllFiles -bool true

  ### Finder: show all filename extensions
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  ### Finder: show status bar
  defaults write com.apple.finder ShowStatusBar -bool true

  ### Finder: show path bar
  defaults write com.apple.finder ShowPathbar -bool true
  echo -e "Finder settings override... Done."
}

keyboard() {
  echo -e "\nKeyboard settings override..."

  ### Disable press-and-hold for keys in favor of key repeat
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

  ### Set a blazingly fast keyboard repeat rate
  defaults write NSGlobalDomain KeyRepeat -int 1
  defaults write NSGlobalDomain InitialKeyRepeat -int 10
  echo -e "Keyboard settings override... Done."
}

hidden_files_and_folders() {
  echo -e "\nHidden files & folders settings override..."

  # Show the ~/Library folder
  chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

  # Show the /Volumes folder
  sudo chflags nohidden /Volumes
  echo -e "Hidden files & folders settings override... Done."
}

activity_monitor() {
  echo -e "\nActivity monitor settings override..."

  # Show all processes in Activity Monitor
  defaults write com.apple.ActivityMonitor ShowCategory -int 0

  # Sort Activity Monitor results by CPU usage
  defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
  defaults write com.apple.ActivityMonitor SortDirection -int 0
  echo -e "Activity monitor settings override... Done."
}

verify_pre_install() {
  read -p "Do you want to override macOS defaults and change key bindings? (y/n): " input
  if [[ ${input} != "y" ]]; then
    echo -e "\nNothing has changed.\n"
    exit 0
  fi
}

main() {
  print_banner
  verify_pre_install

  key_bindings
  finder
  keyboard
  hidden_files_and_folders
  activity_monitor

  # Kill all Finder to apply some settings
  Killall Finder

  echo -e "\nRestart is required !\n"
}

main "$@"