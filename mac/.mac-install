#!/bin/bash

print_banner() {
  echo -e "
███╗   ███╗ █████╗  ██████╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
████╗ ████║██╔══██╗██╔════╝    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
██╔████╔██║███████║██║         ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
██║╚██╔╝██║██╔══██║██║         ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
██║ ╚═╝ ██║██║  ██║╚██████╗    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
"
}

install_key_bindings() {

  echo -e "
=======================================================================
                        Installing KeyBindings
=======================================================================
"

  if [[ ! -d "${HOME}/Library/KeyBindings" ]]; then
    echo "  Installing..."
    mkdir -p ${HOME}/Library/KeyBindings
    cp mac/DefaultKeyBinding.dict ${HOME}/Library/KeyBindings
  else
    echo "  Already installed."
  fi

  echo -e "\n    Done."
}

override_defaults() {

  echo -e "
=======================================================================
                      Overriding macOS Defaults
=======================================================================
"

  echo "  Overriding..."

  ### Finder: show hidden files by default
  defaults write com.apple.finder AppleShowAllFiles -bool true

  ### Finder: show all filename extensions
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  ### Finder: show status bar
  defaults write com.apple.finder ShowStatusBar -bool true

  ### Finder: show path bar
  defaults write com.apple.finder ShowPathbar -bool true

  ### Disable press-and-hold for keys in favor of key repeat
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

  ### Set a blazingly fast keyboard repeat rate
  defaults write NSGlobalDomain KeyRepeat -int 1
  defaults write NSGlobalDomain InitialKeyRepeat -int 10

  # Kill all Finder to apply
  Killall Finder

  echo -e "\n  Restart is required."
  echo -e "\n    Done.\n"
}

verify_pre_install() {
  read -p "Do you want to override macOS defaults and change key bindings? (y/n): " input
  if [[ ${input} != "y" ]]; then
    echo -e "\n    Nothing has changed.\n"
    exit 0
  fi
}

main() {
  print_banner
  verify_pre_install
  install_key_bindings
  override_defaults
}

main "$@"