#!/bin/bash

print_banner() {
  echo -e "
██████╗ ██████╗ ███████╗██╗    ██╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
██╔══██╗██╔══██╗██╔════╝██║    ██║    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
██████╔╝██████╔╝█████╗  ██║ █╗ ██║    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
██╔══██╗██╔══██╗██╔══╝  ██║███╗██║    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
██████╔╝██║  ██║███████╗╚███╔███╔╝    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚══╝╚══╝     ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
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

#
# This file should be executed manually to install all homebrew casks
# Installation paths:
#   - /usr/local/Homebrew - Homebrew cloned repository
#   - /usr/local/Cellar   - Homebrew packages
#   - /usr/local/Caskroom - Homebrew casks
#   - /usr/local/opt      - symlinks to manage versioning to Cellar/Caskroom folders
#

declare -a PACKAGES=("zsh"
  "zsh-syntax-highlighting"
  "fzf"
  "watch"
  "git"
  "vegeta"
  "wget"
  "telnet"
  "kubernetes-cli"
  "kubernetes-helm"
  "gradle"
  "python"
  "derailed/k9s/k9s"
  "graphviz")

declare -a CASKS=("alfred"
  "google-chrome"
  "spotify"
  "tableplus"
  "slack"
  "telegram"
  "whatsapp"
  "sublime-text"
  "visual-studio-code"
  "iterm2"
  "flux"
  "muzzle"
  "postman"
  "spectacle"
  "tunnelbear"
  "zoomus"
  "docker-edge"
  "macpass"
  "kap"
  "typora"
  "licecap")

# Manual Download & install:
#   - IntelliJ IDEA (plugins: Material Theme UI, Atom Material Icons, Rainbow Brackets, Makefile Support)
#   - Goland
#   - JSON xml parser (AppStore)
#   - Monosnap (AppStore)
#   - Unsplash Wallpapers (AppStore)
#   - Be Focused (AppStore)

install_homebrew() {
  echo -e "
=======================================================================
                         Installing HomeBrew
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
  if [[ -z "${PACKAGES}" ]]; then
    return
  fi

  echo -e "
=======================================================================
                      Installing HomeBrew Packages
======================================================================="

  for pkg in "${PACKAGES[@]}"; do
    echo -e "
===================
Installing Package: ${pkg}
===================
"
    brew install ${pkg}
  done
}

# install_casks Function
# -----------------------------------
# Retrieve casks information:
#   - brew search <cask name>
#   - brew cask info <cask name>
# -----------------------------------
install_casks() {
  if [[ -z "${CASKS}" ]]; then
    return
  fi

  echo -e "
=======================================================================
                      Installing HomeBrew Casks
======================================================================="

  for cask in "${CASKS[@]}"; do
    echo -e "
================
Installing Cask: ${cask}
================
"
    brew cask install ${cask}
  done
}

list_all() {
    echo -e "
Installed Homebrew Packages:
----------------------------"
  brew leaves

  echo -e "
Installed Homebrew Casks:
-------------------------"
  brew cask list
}

install_custom() {

  echo -e "
=======================================================================
                     Installing 3rd Party Content
======================================================================="

  echo -e "
===========
Installing: oh-my-zsh
===========
"
  wget -O /tmp/install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
  # --unattended: installer will not change the default shell or run zsh after the install
  sh /tmp/install.sh --unattended

  echo -e "
==================
Installing Plugin: zsh-syntax-highlighting
==================
"
  if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  else
    echo "  Already installed."
  fi

  oh_my_zsh_setup_shell
}

verify_pre_install() {
  read -p "Do you want to install Homebrew with additional packages and casks? (y/n): " input
  if [[ ${input} != "y" ]]; then
    echo -e "\n    Nothing has changed.\n"
    exit 0
  fi
}

# oh-my-zsh overrides
# -----------------------------------
# Override the setup_shell function with its dependant functions
# In order to install custom plugins we need to prevent oh-my-zsh
# to open a new zsh shell after installation completes.
# After installing our custom plugins, we need to execute the rest of the
# oh-my-zsh installation flow to allow zsh as the main shell.
# -----------------------------------
oh_my_zsh_setup_color() {
  # Only use colors if connected to a terminal
  if [ -t 1 ]; then
    RED=$(printf '\033[31m')
    GREEN=$(printf '\033[32m')
    YELLOW=$(printf '\033[33m')
    BLUE=$(printf '\033[34m')
    BOLD=$(printf '\033[1m')
    RESET=$(printf '\033[m')
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    RESET=""
  fi
}

oh_my_zsh_command_exists() {
  command -v "$@" >/dev/null 2>&1
}

oh_my_zsh_error() {
  echo ${RED}"Error: $@"${RESET} >&2
}

oh_my_zsh_setup_shell() {

  oh_my_zsh_setup_color

  # If this user's login shell is already "zsh", do not attempt to switch.
  if [ "$(basename "$SHELL")" = "zsh" ]; then
    return
  fi

  # If this platform doesn't provide a "chsh" command, bail out.
  if ! oh_my_zsh_command_exists chsh; then
    cat <<-EOF
			I can't change your shell automatically because this system does not have chsh.
			${BLUE}Please manually change your default shell to zsh${RESET}
		EOF
    return
  fi

  echo "${BLUE}Time to change your default shell to zsh:${RESET}"

  # Prompt for user choice on changing the default login shell
  printf "${YELLOW}Do you want to change your default shell to zsh? [Y/n]${RESET} "
  read opt
  case $opt in
  y* | Y* | "") echo "Changing the shell..." ;;
  n* | N*)
    echo "Shell change skipped."
    return
    ;;
  *)
    echo "Invalid choice. Shell change skipped."
    return
    ;;
  esac

  # Test for the right location of the "shells" file
  if [ -f /etc/shells ]; then
    shells_file=/etc/shells
  elif [ -f /usr/share/defaults/etc/shells ]; then # Solus OS
    shells_file=/usr/share/defaults/etc/shells
  else
    oh_my_zsh_error "could not find /etc/shells file. Change your default shell manually."
    return
  fi

  # Get the path to the right zsh binary
  # 1. Use the most preceding one based on $PATH, then check that it's in the shells file
  # 2. If that fails, get a zsh path from the shells file, then check it actually exists
  if ! zsh=$(which zsh) || ! grep -qx "$zsh" "$shells_file"; then
    if ! zsh=$(grep '^/.*/zsh$' "$shells_file" | tail -1) || [ ! -f "$zsh" ]; then
      oh_my_zsh_error "no zsh binary found or not present in '$shells_file'"
      oh_my_zsh_error "change your default shell manually."
      return
    fi
  fi

  # We're going to change the default shell, so back up the current one
  if [ -n $SHELL ]; then
    echo $SHELL >~/.shell.pre-oh-my-zsh
  else
    grep "^$USER:" /etc/passwd | awk -F: '{print $7}' >~/.shell.pre-oh-my-zsh
  fi

  # Actually change the default shell to zsh
  if ! chsh -s "$zsh"; then
    oh_my_zsh_error "chsh command unsuccessful. Change your default shell manually."
  else
    export SHELL="$zsh"
    echo "${GREEN}Shell successfully changed to '$zsh'.${RESET}"
  fi

  echo

  exec zsh -l
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
  install_custom
}

main "$@"
