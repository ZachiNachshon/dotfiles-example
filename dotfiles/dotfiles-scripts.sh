#!/bin/bash

# Title        dotfiles-scripts.sh
# Description  Create/remove dotfiles symlinks in/from $HOME folder
# Author       Zachi Nachshon <zachi.nachshon@gmail.com>
#==============================================================================
print_banner() {
  echo -e "
██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝ (shell: ${SHELL})
"
}

print_usage() {
  echo -e "Manage dotfiles symlinks in \$HOME folder

Usage:
  ./dotfiles-scripts.sh [flags]

Flags:
  --install     create symlinks for dotfiles in \$HOME folder
  --uninstall   remove symlinks from \$HOME folder

Use \"./dotfiles-scripts.sh help\" for additional information."
  exit 1
}

install_dotfiles() {
  local output=""

  local DOT_FILES_TO_INSTALL=$(find $(PWD)/dotfiles/files \
    -name ".*" \
    -not -name ".gitignore" \
    -not -name ".travis.yml" \
    -not -name ".git" \
    -not -name ".*.swp" \
    -not -name ".gnupg" \
    -not -name ".idea")

  for file in ${DOT_FILES_TO_INSTALL}; do
    f=$(basename ${file})
    # Install .zsh files only for zsh shell and vice versa for .bash files and bash shell
    if [[ ${f} == *".zsh"* && $(echo ${SHELL}) != *"zsh"* ]]; then
      continue
    elif [[ ${f} == *".bash"* && $(echo ${SHELL}) != *"bash"* ]]; then
      continue
    else
      ln -sfn ${file} ${HOME}/${f}
    fi

    output+="\n  ${f} --> ${file}"
  done

  echo -e "${output}\n"
}

uninstall_dotfiles() {
  local output=""

  local DOT_FILES_TO_UNINSTALL=$(find $(PWD)/dotfiles/files -name ".*" \
    -not -name ".gitignore" \
    -not -name ".travis.yml" \
    -not -name ".git" \
    -not -name ".*.swp" \
    -not -name ".gnupg" \
    -not -name ".idea")

  for file in ${DOT_FILES_TO_UNINSTALL}; do
    f=$(basename ${file})
    # Uninstall .zsh files only for zsh shell and vice versa for .bash files and bash shell
    if [[ ${f} == *".zsh"* && $(echo ${SHELL}) != *"zsh"* ]]; then
      continue
    elif [[ ${f} == *".bash"* && $(echo ${SHELL}) != *"bash"* ]]; then
      continue
    else
      unlink ${HOME}/${f} 2>/dev/null
    fi

    output+="\n  ${f} --> removed."
  done

  echo -e "${output}\n"
}

verify_pre_install() {
  read -p "Do you want to set dotfiles symlinks in [${HOME}]? (y/n): " input
  if [[ ${input} != "y" ]]; then
    echo -e "\n    Nothing has changed.\n"
    exit 0
  fi
}

verify_pre_uninstall() {
  read -p "Do you want to remove dotfiles symlinks from [${HOME}]? (y/n): " input
  if [[ ${input} != "y" ]]; then
    echo -e "\n    Nothing has changed.\n"
    exit 0
  fi
}

main() {
  if [[ $# -eq 0 ]]; then
    print_usage
  fi

  action=$1


  // TODO: Install in a dedicated $HOME/.dotfiles folder

  if [[ ${action} == "--install" ]]; then
    print_banner
    verify_pre_install
    install_dotfiles
  elif [[ ${action} == "--uninstall" ]]; then
    print_banner
    verify_pre_uninstall
    uninstall_dotfiles
  else
    print_usage
  fi
}

main "$@"
