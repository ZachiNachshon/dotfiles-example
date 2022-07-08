#!/bin/bash

# within ~/.local/bin/dotfiles
# ln -sf ~/.config/dotfiles/dotfiles.sh dotfiles
# chmod +x dotfiles

DOTFILES_EXEC_PATH="$HOME/.local/bin/dotfiles"
DOTFILES_REPO_LOCAL_PATH="$HOME/.config/dotfiles"
DOTFILES_FOLDER_LOCATION=dotfiles/

source "${DOTFILES_REPO_LOCAL_PATH}/brew/brew.sh"
source "${DOTFILES_REPO_LOCAL_PATH}/dotfiles/linker.sh"
source "${DOTFILES_REPO_LOCAL_PATH}/os/mac/mac.sh"
source "${DOTFILES_REPO_LOCAL_PATH}/os/linux/linux.sh"
source "${DOTFILES_REPO_LOCAL_PATH}/external/shell_scripts_lib/logger.sh"
source "${DOTFILES_REPO_LOCAL_PATH}/external/shell_scripts_lib/prompter.sh"

SCRIPT_NAME="Dotfiles"

CLI_ARGUMENT_LINK_DOTFILES=""
CLI_ARGUMENT_SYNC_REPO_DOTFILES=""
CLI_ARGUMENT_BREW_COMMAND=""
CLI_ARGUMENT_OS_COMMAND=""
CLI_ARGUMENT_RELOAD_DOTFILES=""
CLI_ARGUMENT_LOCATIONS=""
CLI_ARGUMENT_REPOSITORY=""

CLI_VALUE_BREW_OPTION=""
CLI_VALUE_OS_OPTION=""

CLI_OPTION_DRY_RUN=""
CLI_OPTION_VERBOSE=""
CLI_OPTION_SILENT=""

is_link_dotfiles() {
  [[ -n ${CLI_ARGUMENT_LINK_DOTFILES} ]]
}

is_sync_repo_dotfiles() {
  [[ -n ${CLI_ARGUMENT_SYNC_REPO_DOTFILES} ]]
}

is_brew_command() {
  [[ -n ${CLI_ARGUMENT_BREW_COMMAND} ]]
}

is_os_command() {
  [[ -n ${CLI_ARGUMENT_OS_COMMAND} ]]
}

is_reload_dotfiles() {
  [[ -n ${CLI_ARGUMENT_RELOAD_DOTFILES} ]]
}

is_print_locations() {
  [[ -n ${CLI_ARGUMENT_LOCATIONS} ]]
}

is_change_dir_to_dotfiles_repo() {
  [[ -n ${CLI_ARGUMENT_REPOSITORY} ]]
}

print_cli_used_locations_and_exit() {
  echo -e """${COLOR_WHITE}LOCATIONS${COLOR_NONE}:

  ${COLOR_LIGHT_CYAN}Clone Path${COLOR_NONE}.......: $HOME/.config/dotfiles

${COLOR_WHITE}HOMEBREW PATHS${COLOR_NONE}:

  ${COLOR_LIGHT_CYAN}Brew Repository${COLOR_NONE}...: /usr/local/Homebrew
  ${COLOR_LIGHT_CYAN}Brew Symlinks${COLOR_NONE}.....: /usr/local/opt
  ${COLOR_LIGHT_CYAN}Brew Packages${COLOR_NONE}.....: /usr/local/Cellar
  ${COLOR_LIGHT_CYAN}Brew Casks${COLOR_NONE}........: /usr/local/Caskroom

  ${COLOR_LIGHT_CYAN}Dotfiles Brew Packages${COLOR_NONE}...: $(pwd)/brew/packages.txt
  ${COLOR_LIGHT_CYAN}Dotfiles Brew Casks${COLOR_NONE}......: $(pwd)/brew/casks.txt
  ${COLOR_LIGHT_CYAN}Dotfiles Brew Drivers${COLOR_NONE}....: $(pwd)/brew/drivers.txt
  ${COLOR_LIGHT_CYAN}Dotfiles Brew Services${COLOR_NONE}...: $(pwd)/brew/services.txt
 
${COLOR_WHITE}ENV VARS${COLOR_NONE}:

  ${COLOR_LIGHT_CYAN}TEST_ENV_VAR${COLOR_NONE}..: test
"""
  exit 0
}

reload_managed_files_inner() {
  if ! is_dry_run; then
    for file in $(find ${DOTFILES_REPO_LOCAL_PATH}/dotfiles/managed -name ".*"); do
    #  echo "${file}"
      source ${file}
    done
  fi  
  log_indicator_good "Sourced managed dotfiles"
}

reload_transient_files() {
  if ! is_dry_run; then
    for file in $(find ${DOTFILES_REPO_LOCAL_PATH}/dotfiles/transient -name ".*"); do
    #  echo "${file}"
      source ${file}
    done
  fi  
  log_indicator_good "Sourced transient dotfiles"
}

reload_custom_files_inner() {
  if ! is_dry_run; then
    for file in $(find ${DOTFILES_REPO_LOCAL_PATH}/dotfiles/custom -name ".*"); do
    #  echo "${file}"
      source ${file}
    done
  fi  
  log_indicator_good "Sourced custom dotfiles"
}

reload_active_shell_session_and_exit() {
  reload_managed_files_inner
  reload_transient_files
  reload_custom_files_inner
  exit 0
}

run_link_command_and_exit() {
  run_dotfiles_link_command
  exit 0
}

run_brew_command_and_exit() {
  run_homebrew_command "${CLI_VALUE_BREW_OPTION}"
  exit 0
}

run_os_settings_command_and_exit() {
  if [[ "${CLI_VALUE_OS_OPTION}" == "mac" ]]; then
    run_os_mac_settings_command
  elif [[ "${CLI_VALUE_OS_OPTION}" == "linux" ]]; then
    run_os_linux_settings_command
  else
    log_fatal "Option not supoprted. value: ${CLI_VALUE_OS_OPTION}"
  fi
  exit 0
}

change_dir_to_dotfiles_local_repo_and_exit() {
  if ! is_directory_exist "${DOTFILES_REPO_LOCAL_PATH}"; then
    log_fatal "Invalid dotfiles directory, forgot to install/clone? path: ${DOTFILES_REPO_LOCAL_PATH}"
  fi

  log_info "Changing directory to ${DOTFILES_REPO_LOCAL_PATH}"  
  cd "${DOTFILES_REPO_LOCAL_PATH}" || exit
  # Read the following link to understand why we should use SHELL in here
  # https://unix.stackexchange.com/a/278080
  $SHELL
  exit 0
}

print_help_menu_and_exit() {
  local exec_filename=$1
  local base_exec_filename=$(basename "${exec_filename}")
  echo -e "${SCRIPT_NAME} - Manage a local development environment"
  echo -e " "
  echo -e "${COLOR_WHITE}USAGE${COLOR_NONE}"
  echo -e "  "${base_exec_filename}" [command] [flag]"
  echo -e " "
  echo -e "${COLOR_WHITE}AVAILABLE COMMANDS${COLOR_NONE}"
  echo -e "  ${COLOR_LIGHT_CYAN}link${COLOR_NONE}                      Link all dotfiles from folder ${COLOR_GREEN}${DOTFILES_FOLDER_LOCATION}${COLOR_NONE}"
  echo -e "  ${COLOR_LIGHT_CYAN}brew${COLOR_NONE} [option]             Update local brew components (options: packages/casks/drivers/services/all)"
  echo -e "  ${COLOR_LIGHT_CYAN}os${COLOR_NONE} [option]               Update OS settings and preferences (options: mac/linux)"
  echo -e "  ${COLOR_LIGHT_CYAN}reload${COLOR_NONE}                    Reload active shell session"
  echo -e "  ${COLOR_LIGHT_CYAN}locations${COLOR_NONE}                 Print locations used for config/repositories/symlinks/clone-path"
  echo -e "  ${COLOR_LIGHT_CYAN}init${COLOR_NONE}                      Prompt for dotfiles git repo and perform a fresh clone"
  echo -e "  ${COLOR_LIGHT_CYAN}update${COLOR_NONE}                    Update or fresh clone the dotfiles repo and link afterwards"
  echo -e "  ${COLOR_LIGHT_CYAN}repo${COLOR_NONE}                      Change directory to the ${base_exec_filename} local git repository"
  echo -e " "
  echo -e "${COLOR_WHITE}FLAGS${COLOR_NONE}"
  echo -e "  ${COLOR_LIGHT_CYAN}--dry-run${COLOR_NONE}                 Run all commands in dry-run mode without file system changes"
  echo -e "  ${COLOR_LIGHT_CYAN}-y${COLOR_NONE}                        Do not prompt for approval and accept everything"
  echo -e "  ${COLOR_LIGHT_CYAN}-h${COLOR_NONE} (--help)               Show available actions and their description"
  echo -e "  ${COLOR_LIGHT_CYAN}-v${COLOR_NONE} (--verbose)            Output debug logs for deps-syncer client commands executions"
  echo -e "  ${COLOR_LIGHT_CYAN}-s${COLOR_NONE} (--silent)             Do not output logs for deps-syncer client commands executions"
  echo -e " "
  exit 0
}

parse_program_arguments() {
  if [ $# = 0 ]; then
    print_help_menu_and_exit "$0"
  fi

  while test $# -gt 0; do
    case "$1" in
    -h | --help)
      print_help_menu_and_exit "$0"
      shift
      ;;
    sync)
      CLI_ARGUMENT_SYNC_REPO_DOTFILES="sync"
      shift
      ;;
    reload)
      CLI_ARGUMENT_RELOAD_DOTFILES="reload"
      shift
      ;;
    brew)
      CLI_ARGUMENT_BREW_COMMAND="brew"
      shift
      CLI_VALUE_BREW_OPTION=$1
      shift
      ;;
    os)
      CLI_ARGUMENT_OS_COMMAND="brew"
      shift
      CLI_VALUE_OS_OPTION=$1
      shift
      ;;
    repo)
      CLI_ARGUMENT_REPOSITORY="repo"
      shift
      ;;
    locations)
      CLI_ARGUMENT_LOCATIONS="locations"
      shift
      ;;
    --dry-run)
      # Used by logger.sh
      export LOGGER_DRY_RUN="true"
      # Used by brew.sh
      export CLI_OPTION_DRY_RUN="true"
      shift
      ;;
    -y)
      # Used by prompter.sh
      export PROMPTER_SKIP_PROMPT="y"
      shift
      ;;
    -v | --verbose)
      # Used by brew.sh
      export CLI_OPTION_VERBOSE="verbose"
      shift
      ;;
    -s | --silent)
      # Used by logger.sh
      export LOGGER_SILENT="true"
      # Used by brew.sh
      export CLI_OPTION_SILENT="true"
      shift
      ;;
    *)
      print_help_menu_and_exit "$0"
      shift
      ;;
    esac
  done

  # Set defaults
  CLI_OPTION_VERBOSE=${CLI_OPTION_VERBOSE=''}
  CLI_OPTION_DRY_RUN=${CLI_OPTION_DRY_RUN=''}
  CLI_OPTION_SILENT=${CLI_OPTION_SILENT=''}
}

verify_program_arguments() {
  # Verify proper command args ordering: dotfiles brew casks --dry-run -v
  if check_invalid_brew_command_value; then
    log_fatal "Brew command is missing a mandatory option. options: packages/casks/drivers/services/all"
  elif check_invalid_os_command_value; then
    log_fatal "Brew command is missing a mandatory option. options: packages/casks/drivers/services/all"
  fi

  # elif [[ -z "${binary_name}" ]]; then
  #   log_fatal "Missing mandatory param. name: binary_name"
  # elif [[ -z "${dist_path}" ]]; then
  #   log_fatal "Missing mandatory param. name: dist_path"
  # elif [[ -z "${go_files_path}" ]]; then
  #   log_fatal "Missing mandatory param. name: go_files_path"
  # fi
}

check_invalid_brew_command_value() {
  # If brew command is not empty and its value is a flag - not valid
  [[ -n "${CLI_ARGUMENT_BREW_COMMAND}" && (-z "${CLI_VALUE_BREW_OPTION}" || "${CLI_VALUE_BREW_OPTION}" == -*) ]]
}

check_invalid_os_command_value() {
  # If brew command is not empty and its value is a flag - not valid
  [[ -n "${CLI_ARGUMENT_OS_COMMAND}" && (-z "${CLI_VALUE_OS_OPTION}" || "${CLI_VALUE_OS_OPTION}" == -*) ]]
}

is_dry_run() {
  [[ -n "${CLI_OPTION_DRY_RUN}" ]]
}

is_debug() {
  [[ -n "${CLI_OPTION_VERBOSE}" ]]
}

is_silent() {
  [[ -n "${CLI_OPTION_SILENT}" ]]
}

main() {
  parse_program_arguments "$@"
  verify_program_arguments

  if is_change_dir_to_dotfiles_repo; then
    change_dir_to_dotfiles_local_repo_and_exit
  fi

  if is_print_locations; then
    print_cli_used_locations_and_exit
  fi

  if is_link_dotfiles; then
    run_link_command_and_exit
  fi

  if is_brew_command; then
    run_brew_command_and_exit
  fi

  if is_os_command; then
    run_os_settings_command_and_exit
  fi

  if is_reload_dotfiles; then
    reload_active_shell_session_and_exit
  fi
}

main "$@"