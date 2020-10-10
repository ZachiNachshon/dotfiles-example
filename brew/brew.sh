#!/bin/bash

# Title        brew.sh
# Description  Install/upgrade Homebrew packages and casks
# Author       Zachi Nachshon <zachi.nachshon@gmail.com>
#==============================================================================
print_banner() {
  echo -e "
██╗  ██╗ ██████╗ ███╗   ███╗███████╗██████╗ ██████╗ ███████╗██╗    ██╗
██║  ██║██╔═══██╗████╗ ████║██╔════╝██╔══██╗██╔══██╗██╔════╝██║    ██║
███████║██║   ██║██╔████╔██║█████╗  ██████╔╝██████╔╝█████╗  ██║ █╗ ██║
██╔══██║██║   ██║██║╚██╔╝██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██║███╗██║
██║  ██║╚██████╔╝██║ ╚═╝ ██║███████╗██████╔╝██║  ██║███████╗╚███╔███╔╝
╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚══╝╚══╝
"
}

# Homebrew cheatsheet
# -----------------------------------
# brew install git          Install a package
# brew install git@2.0.0    Install a package with specific version
# brew uninstall git        Uninstall a package
# brew upgrade git          Upgrade a package
# brew unlink git           Unlink
# brew link git             Link
# brew switch git 2.5.0     Change versions
# brew list --versions git  See what versions you have
# --
# brew info git             List versions, caveats, etc
# brew cleanup git          Remove old versions
# brew edit git             Edit this formula
# brew cat git              Print this formula
# brew home git             Open homepage
# --
# brew update               Update brew and cask
# brew list                 List installed
# brew outdated             What’s due for upgrades?
# -----------------------------------

# Installation paths:
#   - /usr/local/Homebrew - Homebrew cloned repository
#   - /usr/local/Cellar   - Homebrew packages
#   - /usr/local/Caskroom - Homebrew casks
#   - /usr/local/opt      - symlinks to manage versioning to Cellar/Caskroom folders
#

install_homebrew() {
  echo -e "
=======================================================================
                         Installing Homebrew
=======================================================================
"
  if [[ ! -d "/usr/local/Homebrew" ]]; then
    echo "==> Installing..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    echo "==> Already installed."
  fi
}

install_homebrew_taps() {
  echo -e "Tapping to homebrew/cask-versions...\n"
  # cask-versions enable us to search supported versions by providing a cask name:
  #   - brew search <cask name>
  brew tap homebrew/cask-versions
}

keep_brew_up_to_date() {
  echo -e "
=======================================================================
                      Upgrading Outdated Plugin
======================================================================="
  brew outdated
  brew update
  brew upgrade
}

install_packages() {
  echo -e "
=======================================================================
                      Installing HomeBrew Packages
======================================================================="

  packages_filename='brew/packages.txt'
  while read pkg; do
    # reading each line
    echo -e "
===================
Installing Package: ${pkg}
===================
"
    brew install ${pkg}

  done < ${packages_filename}
}

# install_casks Function
# -----------------------------------
# Retrieve casks information:
#   - brew search <cask name>
#   - brew cask info <cask name>
# -----------------------------------
install_casks() {
  echo -e "
=======================================================================
                      Installing HomeBrew Casks
======================================================================="

  casks_filename='brew/casks.txt'
  while read cask; do
    # reading each line
    echo -e "
================
Installing Cask: ${cask}
================
"
    brew cask install ${cask}

  done < ${casks_filename}
}

list_all() {
    echo -e "
Installed Homebrew Packages:
----------------------------"
  brew leaves

  echo -e "
Installed Homebrew Casks:
-------------------------"
  brew list --cask
}

verify_pre_install() {
  read -p "Do you want to install/upgrade Homebrew with additional packages and casks? (y/n): " input
  if [[ ${input} != "y" ]]; then
    echo -e "\n    Nothing has changed.\n"
    exit 0
  fi
}

main() {
  print_banner
  verify_pre_install
  install_homebrew
  install_homebrew_taps
  keep_brew_up_to_date
  install_packages
  install_casks
  list_all

  # Assuming this script was executed via makefile
  source brew/shell/oh-my-zsh-install.sh
  oh_my_zsh_setup_install
}

main "$@"
