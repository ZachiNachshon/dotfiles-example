#!/bin/bash

# Title        dotfiles.sh
# Description  Create or remove symlinks for this repository
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

install_dotfiles() {
  mkdir -p ${DOTFILES_HOME_DIR}
  _symlink_config_in_dotfiles_dir
  _symlink_shells_in_home_dir
  _symlink_home_files_in_dotfiles_dir
  _symlink_managed_files_in_dotfiles_dir
  _symlink_custom_files_in_dotfiles_dir
}

_symlink_config_in_dotfiles_dir() {
  ln -sfn ${PWD}/config.sh ${DOTFILES_HOME_DIR}/.config
  echo -e "\nConfig:\n  ${DOTFILES_HOME_DIR}/.config --> ${PWD}/config.sh"
}

_symlink_shells_in_home_dir() {
  local output=""
  local DOT_FILES_TO_INSTALL_IN_HOME_DIR=$(find $(PWD)/dotfiles/shell -name ".*")

  for file in ${DOT_FILES_TO_INSTALL_IN_HOME_DIR}; do
    f=$(basename ${file})
    # Install .zsh files only for zsh shell and vice versa for .bash files and bash shell
    if [[ ${f} == *".zsh"* && $(echo ${SHELL}) == *"zsh"* ]]; then
      ln -sfn ${file} ${HOME}/${f}
      output+="\n  ${HOME}/${f} --> ${file}"
    elif [[ ${f} == *".bash"* && $(echo ${SHELL}) == *"bash"* ]]; then
      ln -sfn ${file} ${HOME}/${f}
      output+="\n  ${HOME}/${f} --> ${file}"
    fi
  done

  echo -e "\nShell:${output}"
}

_symlink_home_files_in_dotfiles_dir() {
  local output=""
  local DOT_FILES_TO_INSTALL=$(find $(PWD)/dotfiles/home -name ".*")

  for file in ${DOT_FILES_TO_INSTALL}; do
    f=$(basename ${file})
    ln -sfn ${file} ${HOME}/${f}
    output+="\n  ${HOME}/${f} --> ${file}"
  done

  echo -e "\nHome:${output}"
}

_symlink_managed_files_in_dotfiles_dir() {
  local output=""
  local DOT_FILES_TO_INSTALL=$(find $(PWD)/dotfiles/managed -name ".*")

  mkdir -p ${DOTFILES_HOME_DIR}/managed

  for file in ${DOT_FILES_TO_INSTALL}; do
    f=$(basename ${file})
    ln -sfn ${file} ${DOTFILES_HOME_DIR}/managed/${f}
    output+="\n  ${DOTFILES_HOME_DIR}/managed/${f} --> ${file}"
  done

  echo -e "\nManaged:${output}"
}

_symlink_custom_files_in_dotfiles_dir() {
  local output=""

  local DOT_FILES_TO_INSTALL=$(find $(PWD)/dotfiles/custom \
    -name ".*" \
    -not -name ".gitignore" \
    -not -name ".travis.yml" \
    -not -name ".git" \
    -not -name ".*.swp" \
    -not -name ".gnupg" \
    -not -name ".idea")

  mkdir -p ${DOTFILES_HOME_DIR}/custom

  for file in ${DOT_FILES_TO_INSTALL}; do
    f=$(basename ${file})
    ln -sfn ${file} ${DOTFILES_HOME_DIR}/custom/${f}
    output+="\n  ${DOTFILES_HOME_DIR}/custom/${f} --> ${file}"
  done

  echo -e "\nCustom:${output}\n"
}

uninstall_dotfiles() {
  _unlink_config_in_dotfiles_dir
  _unlink_shells_in_home_dir
  _unlink_managed_files_in_dotfiles_dir
  _unlink_custom_files_in_dotfiles_dir

  if [[ ${DOTFILES_HOME_DIR} != ${HOME} && -d ${DOTFILES_HOME_DIR} && ${DOTFILES_HOME_DIR} == *"dotfiles"* ]]; then
    rm -r ${DOTFILES_HOME_DIR}
    output+="\nCleanup:\n  ${DOTFILES_HOME_DIR} --> removed."
  fi
}

_unlink_config_in_dotfiles_dir() {
  unlink ${DOTFILES_HOME_DIR}/.config 2>/dev/null
  echo -e "\nConfig:\n  ${DOTFILES_HOME_DIR}/.config --> removed."
}

_unlink_shells_in_home_dir() {
  local output=""

  local DOT_FILES_TO_UNINSTALL=$(find $(PWD)/dotfiles/shell -name ".*" \
    -not -name ".gitignore" \
    -not -name ".travis.yml" \
    -not -name ".git" \
    -not -name ".*.swp" \
    -not -name ".gnupg" \
    -not -name ".idea")

  for file in ${DOT_FILES_TO_UNINSTALL}; do
    f=$(basename ${file})
    # Uninstall .zsh files only for zsh shell and vice versa for .bash files and bash shell
    if [[ ${f} == *".zsh"* && $(echo ${SHELL}) == *"zsh"* ]]; then
      unlink ${HOME}/${f} 2>/dev/null
      output+="\n  ${HOME}/${f} --> removed."
    elif [[ ${f} == *".bash"* && $(echo ${SHELL}) == *"bash"* ]]; then
      unlink ${HOME}/${f} 2>/dev/null
      output+="\n  ${HOME}/${f} --> removed."
    fi
  done

  echo -e "\nShell:${output}"
}

_unlink_managed_files_in_dotfiles_dir() {
  local output=""

  local DOT_FILES_TO_UNINSTALL=$(find $(PWD)/dotfiles/managed -name ".*" \
    -not -name ".gitignore" \
    -not -name ".travis.yml" \
    -not -name ".git" \
    -not -name ".*.swp" \
    -not -name ".gnupg" \
    -not -name ".idea")

  for file in ${DOT_FILES_TO_UNINSTALL}; do
    f=$(basename ${file})
    unlink ${DOTFILES_HOME_DIR}/managed/${f} 2>/dev/null
    output+="\n  ${DOTFILES_HOME_DIR}/managed/${f} --> removed."
  done

  echo -e "\nManaged:${output}"
}

_unlink_custom_files_in_dotfiles_dir() {
  local output=""

  local DOT_FILES_TO_UNINSTALL=$(find $(PWD)/dotfiles/custom -name ".*" \
    -not -name ".gitignore" \
    -not -name ".travis.yml" \
    -not -name ".git" \
    -not -name ".*.swp" \
    -not -name ".gnupg" \
    -not -name ".idea")

  for file in ${DOT_FILES_TO_UNINSTALL}; do
    f=$(basename ${file})
    unlink ${DOTFILES_HOME_DIR}/custom/${f} 2>/dev/null
    output+="\n  ${DOTFILES_HOME_DIR}/custom/${f} --> removed."
  done

  echo -e "\nCustom:${output}\n"
}

run_dotfiles_action() {
  action=$1

  if [[ ${action} == "--install" ]]; then
    install_dotfiles
  elif [[ ${action} == "--uninstall" ]]; then
    uninstall_dotfiles
  fi
}

print_selection() {
  echo -e "Manage dotfiles symlinks in folder - ${DOTFILES_HOME_DIR}

  1. Create symlinks for dotfiles, shell scripts and transient content
  2. Remove all symlinks created by this script
"
}

select_option() {
  print_selection
  read -p "Please Choose: " input
  if [[ ${input} == "1" ]]; then
    run_dotfiles_action "--install"
  elif [[ ${input} == "2" ]]; then
    run_dotfiles_action "--uninstall"
  else
    echo -e "\n    Nothing has changed.\n"
    exit 0
  fi
}

main() {
  # This script assumes it was executed via makefile on repo root
  source ${PWD}/config.sh
  print_banner
  select_option
}

main "$@"
