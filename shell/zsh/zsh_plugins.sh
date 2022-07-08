#!/bin/bash

source "${DOTFILES_REPO_LOCAL_PATH}/external/shell_scripts_lib/logger.sh"
source "${DOTFILES_REPO_LOCAL_PATH}/external/shell_scripts_lib/prompter.sh"
source "${DOTFILES_REPO_LOCAL_PATH}/external/shell_scripts_lib/io.sh"

# oh-my-zsh overrides
# -----------------------------------
# Override the setup_shell function with its dependant functions
# In order to install custom plugins we need to prevent oh-my-zsh
# to open a new zsh shell after installation completes.
# After installing our custom plugins, we need to execute the rest of the
# oh-my-zsh installation flow to allow zsh as the main shell.
# -----------------------------------
_oh_my_zsh_setup_color() {
  # Only use colors if connected to a terminal
  if [[ -t 1 ]]; then
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

_oh_my_zsh_command_exists() {
  command -v "$@" >/dev/null 2>&1
}

_oh_my_zsh_error() {
  echo ${RED}"Error: $@"${RESET} >&2
}

_oh_my_zsh_setup_shell() {

  _oh_my_zsh_setup_color

  # If this user's login shell is already "zsh", do not attempt to switch.
  if [[ "$(basename "$SHELL")" = "zsh" ]]; then
    return
  fi

  # If this platform doesn't provide a "chsh" command, bail out.
  if ! _oh_my_zsh_command_exists chsh; then
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
  if [[ -f /etc/shells ]]; then
    shells_file=/etc/shells
  elif [[ -f /usr/share/defaults/etc/shells ]]; then # Solus OS
    shells_file=/usr/share/defaults/etc/shells
  else
    _oh_my_zsh_error "could not find /etc/shells file. Change your default shell manually."
    return
  fi

  # Get the path to the right zsh binary
  # 1. Use the most preceding one based on $PATH, then check that it's in the shells file
  # 2. If that fails, get a zsh path from the shells file, then check it actually exists
  if ! zsh=$(which zsh) || ! grep -qx "$zsh" "$shells_file"; then
    if ! zsh=$(grep '^/.*/zsh$' "$shells_file" | tail -1) || [[ ! -f "$zsh" ]]; then
      _oh_my_zsh_error "no zsh binary found or not present in '$shells_file'"
      _oh_my_zsh_error "change your default shell manually."
      return
    fi
  fi

  # We're going to change the default shell, so back up the current one
  if [[ -n $SHELL ]]; then
    echo $SHELL >~/.shell.pre-oh-my-zsh
  else
    grep "^$USER:" /etc/passwd | awk -F: '{print $7}' >~/.shell.pre-oh-my-zsh
  fi

  # Actually change the default shell to zsh
  if ! chsh -s "$zsh"; then
    _oh_my_zsh_error "chsh command unsuccessful. Change your default shell manually."
  else
    export SHELL="$zsh"
    echo "${GREEN}Shell successfully changed to '$zsh'.${RESET}"
  fi

  echo

  exec zsh -l
}

_oh_my_zsh_install() {
  log_info "Installing oh-my-zsh and ZSH plugins..."

  echo -e "
===========
Installing: oh-my-zsh
===========
"

  if is_debug; then
    echo """
    wget -O /tmp/install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
    sh /tmp/install.sh --unattended
    """
  fi
  if ! is_dry_run; then
    wget -O /tmp/install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
    # --unattended: installer will not change the default shell or run zsh after the install
    sh /tmp/install.sh --unattended
  fi
 
  echo -e "
==================
Installing Plugin: zsh-syntax-highlighting
==================
"
  if is_debug; then
    echo """
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    """
  fi
  if ! is_dry_run; then
    if ! is_directory_exist "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"; then
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    else
      log_info "Plugins aleady installed. name: zsh-syntax-highlighting"
    fi
  fi

  _oh_my_zsh_setup_shell
}

oh_my_zsh_setup() {

  if [[ "$(basename "$SHELL")" != "zsh" ]]; then
    log_warning "Skipping oh-my-zsh installation, shell is not zsh."
    return
  fi

  if ! is_directory_exist "$HOME/.oh-my-zsh"; then
    _oh_my_zsh_install
  else
    log_info "Identified a local installation of oh-my-zsh"
  fi 
}

run_zsh_command() {

}