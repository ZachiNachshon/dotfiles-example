# dotfiles
A curated list of `dotfiles` I use for my local development environment.

![dotfiles-logo-resized](assets/logos/dotfiles-logo-resized.png)

## What is it?
This will create symlinks from this repo to your home folder.<br/>
Additionally, this repository contains:
- [Homebrew](https://github.com/Homebrew/brew) installation script for common packages and casks that I use
- macOS custom KeyBindings, Finder customizations and keyboard preferences

## Getting Started

List of available `make` commands:

1. `install`   - create symlink from this repo to $HOME folder
2. `uninstall` - remove all symlinks from $HOME folder
3. `brew`      - (optional) installs commonly used Homebrew packages and casks
4. `mac`       - (optional) install macOS KeyBindings, setup finder customizations and keyboard preferences
5. `all`       - (optional) execute `install`, `brew` and `mac` in this order

## Customization

Set `DOT_FILES` and other env vars in an `.exports` file, that looks something like this:
```bash
export CODEBASE=${HOME}/codebase
export ENVIRONMENT=${HOME}/environment
export UTILITIES=${HOME}/utilities

export DOT_FILES=${CODEBASE}/github/dotfiles
export DOCKER_FILES=${CODEBASE}/github/dockerfiles
export TERRAFORM_FILES=${CODEBASE}/github/terraformfiles
```

## Quick Start Guide

![](assets/gifs/dotfiles-make-install-700px.gif)