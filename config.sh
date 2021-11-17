#!/bin/bash


# Description  ENV var specifying dotfiles destination directory
# ==============================================================
export DOTFILES_HOME_DIR=${HOME}/.dotfiles


# Description  ENV var dotfiles repository path (+alias)
# ======================================================
SCRIPT=$(greadlink -f "$0")

export DOTFILES_REPO=$(dirname "$SCRIPT")
alias dotfiles=${DOTFILES_REPO}

# Description  ENV var specifying codebase root folder
# ====================================================
SCRIPT=$(greadlink -f "$0")

export CODEBASE=$(dirname $DOTFILES_REPO)

# Description  ENV var specifying environmental settings e.g. Go, JDK etc..
# =========================================================================
export ENVIRONMENT=${HOME}/environment

reload_dot_files() {
  _reload_managed_files_inner
  _reload_transient_files
  _reload_custom_files_inner
}

_reload_managed_files_inner() {
  for file in $(find ${DOTFILES_REPO}/dotfiles/managed -name ".*"); do
#    echo "${file}"
    source ${file}
  done
}

_reload_transient_files() {
  for file in $(find ${DOTFILES_REPO}/dotfiles/transient -name ".*"); do
#    echo "${file}"
    source ${file}
  done
}

_reload_custom_files_inner() {
  for file in $(find ${DOTFILES_REPO}/dotfiles/custom -name ".*"); do
#    echo "${file}"
    source ${file}
  done
}