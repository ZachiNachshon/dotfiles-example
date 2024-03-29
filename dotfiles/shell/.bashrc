#!/bin/bash

############################################################################# 
#           THIS SECTION IS AUTO-GENERATED BY THE dotfiles CLI 
# 
#                         dotfiles RELOAD SESSION 
#                (https://github.com/ZachiNachshon/dotfiles-cli) 
# Limitation: 
# It is not possible to tamper with parent shell process from a nested shell. 
# 
# Solution: 
# The dotfiles reload command creates a new shell session which in turn 
# run the RC file (this file). 
# The following script will source a reload_session.sh script under 
# current shell session without creating a nested shell session. 
############################################################################# 
DOTFILES_CLI_INSTALL_PATH=${DOTFILES_CLI_INSTALL_PATH:-${HOME}/.config/dotfiles-cli} 
DOTFILES_CLI_RELOAD_SESSION_SCRIPT_PATH=${DOTFILES_CLI_INSTALL_PATH}/reload_session.sh 
 
if [[ -e ${DOTFILES_CLI_RELOAD_SESSION_SCRIPT_PATH} ]]; then 
  export LOGGER_SILENT=True 
  source ${DOTFILES_CLI_RELOAD_SESSION_SCRIPT_PATH} 
else 
  echo -e 'Dotfiles CLI is not installed, cannot load plugins/reload session. path: $DOTFILES_CLI_INSTALL_PATH' 
fi
