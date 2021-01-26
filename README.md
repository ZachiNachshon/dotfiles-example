<h3 align="center" id="dotfiles-logo">
  <img src="docs/assets/logos/dotfiles-logo.png" width=500 align="middle"/>
</h3>


## What is it?

A curated list of `.dotfiles` I use for my local development environment. This repository intended to consolidate and manage commonly used `.dotfiles` into a single place backed by a git repository.<br/>
It creates symlinks from [dotfiles directory](dotfiles) in the following manner:

- `~/.dotfiles/.config` - directories paths of *dotfiles repo* and *.dotfiles symlinks* + reload symlinks function
- `~/.dotfiles/managed/*.*` - content to symlink across all machines
- `~/.dotfiles/custom/*.*` - content to symlink in specific machines e.g. work related / personal etc..

Additionally, this repository contains:
- [Homebrew](https://github.com/Homebrew/brew) installation script for common [packages and casks](brew) that I use
- macOS custom KeyBindings, Finder customizations, keyboard preferences and other overrides

<br>

## Getting Started

List of available `make` commands:

1. `dotfiles`   - create/remove dotfiles symlinks to/from this repo
1. `brew` - (*optional*) install commonly used Homebrew [packages and casks](brew)
1. `mac`  - (*optional*) macOS custom KeyBindings, Finder customizations, keyboard preferences and other overrides
1. `all` - (*optional*) execute `mac`, `dotfiles` and `brew` in this order
1. `help` - (*optional*) get available actions

<br>

## Customization

<u>**Custom**</u>

Just add any custom dotfile to `<repo-root>/dotfiles/custom/*.*` and it'll be sourced on every new shell.

**<u>Managed</u>**

For a managed content to be added across all machines using this dotfiles repo, add it to the relevant file:

- `.aliases`
- `.functions`
- `.paths`

### Transient Files

If files in `<repo-root>/dotfiles/transient` directory exists, they will be sourced along but won't get symlinked anywhere.<br/>
You can use this to export ENV vars with sensitive information such as secrets to become available an newly opened shells. Files under `transient` folder are git ignored by default to prevent from committing to a public repository.

| :warning: Warning |
| :--------------------------------------- |
| It is not recommended to commit the `.secrets` transient file as it may contain sensitive information. |

    .
    ├── ...
    ├── dotfiles               
    │   └── custom  # dotfiles to symlink in specific machines e.g. work related / personal etc..
    │       ├── .my-company  
    │       └── ...
    │   └── home  # files that should get symlinked in HOME folder
    │       ├── .gitignore_global       
    │       └── ...
    │   └── managed  # dotfiles to symlink across all machines
    │       ├── .aliases
    │       └── ...
    │   └── shell  # shell run commands to gets sourced on new shell session (+run command to load dotfiles)
    │       ├── .zshrc
    │       └── ...
    │   └── transient # content that gets sourced on new shell session but not symlinked
    │       └── .secrets       
    │   └── .dotfiles.sh  # dotfiles install/uninstall management script 
    └── ...

<br>

## Quick Start Guide

####  `make dotfiles` (install dotfiles)

<details><summary>Show</summary>
<img src="docs/assets/gifs/dotfiles-install.gif" alt="dotfiles-install" />
</details>
<br>

#### `make dotfiles` (uninstall dotfiles)

<details><summary>Show</summary>
<img src="docs/assets/gifs/dotfiles-uninstall.gif" alt="dotfiles-uninstall" />
</details>
<br>

#### `make brew` (install Homebrew packages/casks)

<details><summary>Show</summary>
<img src="docs/assets/gifs/brew.gif" alt="brew" />
</details>
<br>

#### `make mac` (override macOS with custom setting)

<details><summary>Show</summary>
<img src="docs/assets/gifs/mac-install.gif" alt="mac" />
</details>
<br>

<sup><b>Credits: </b><a href=https://github.com/jglovier/dotfiles-logo>Logo</a> created by <a href=https://github.com/jglovier>Joel Glovier</a></sup>