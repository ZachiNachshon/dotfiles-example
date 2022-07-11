#!/bin/bash

###########################################################################
#                             .dotfiles RELOAD
###########################################################################
is_tool_exist() {
  local name=$1
  [[ $(command -v "${name}") ]]
}

if is_tool_exist "dotfiles"; then
  dotfiles reload
else
  echo -e "Dotfiles will not reload, missing CLI utility. name: dotfiles"
fi
###########################################################################