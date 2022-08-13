<h3 align="center" id="dotfiles-logo">
  <img src="docs/assets/logos/dotfiles-logo-orig.png" width=500 align="middle"/>
</h3>

<p align="center">
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"/>
  </a>
  <a href="https://www.paypal.me/ZachiNachshon">
    <img src="https://img.shields.io/badge/$-donate-ff69b4.svg?maxAge=2592000&amp;style=flat">
  </a>
</p>

<p align="center">
  <a href="#requirements">Requirements</a> •
  <a href="#quickstart">QuickStart</a> •
  <a href="#overview">Overview</a> •
  <a href="#support">Support</a> •
  <a href="#license">License</a>
</p>
<br>

An example of a `dotfiles` repository used for a local development environment. This repository is curated and managed via [dotfiles-cli](https://zachinachshon.com/dotfiles-cli/) utility which simplifies the complex dotfiles repository wiring by separating the files from the management layer, allowing to consolidate and manage dotfiles, settings and perferences in a single place backed by a remote git repository.

<br>

<h2 id="requirements">🏁 Requirements</h2>

- A Unix-like operating system: macOS, Linux
- `git` (recommended `v2.30.0` or higher)
- `dotfiles-cli` ([download](https://zachinachshon.com/dotfiles-cli/docs/latest/getting-started/download/))

<br>

<h2 id="overview">🔍 Overview</h2>

- [Dotfiles Repo Structure](#dotfiles-repo-structure)
  - [brew](#brew)
  - [dotfiles](#dotfiles)
    - [custom](#custom)
    - [home](#home)
    - [session](#session)
    - [shell](#shell)
    - [transient](#transient)
  - [os](#os)
  - [plugins](#plugins)
- [Documentation](#documentation)

<br>

<h2 id="dotfiles-repo-structure">Dotfiles Repo Structure</h2>

This is the expected dotfiles repository structure to properly integrate with `dotfiles-cli`:

```bash
.
├── ...
├── brew                     # Homebrew components, items on each file should be separated by a new line
│   ├── casks.txt
│   ├── drivers.txt
│   ├── packages.txt
│   ├── services.txt
│   └── taps.txt
│
├── dotfiles               
│   ├── custom               # Custom files to source on every new shell session (work/personal)
│   │   ├── .my-company  
│   │   └── ...
│   ├── home                 # Files to symlink into HOME folder
│   │   ├── .gitconfig       
│   │   ├── .vimrc
│   │   └── ...
│   ├── session              # Files to source on new shell sessions
│   │   ├── .aliases
│   │   └── ...
│   ├── shell                # Shell run commands files to symlink into HOME folder
│   │   ├── .zshrc
│   │   └── ...
│   └── transient            # Files to source on new shell session (not symlinked, can be git-ignored)
│       └── .secrets
│
├── os
│   ├── linux                # Scripts to configure Linux settings and preferences
│   │   ├── key_bindings.sh
│   │   └── ...
│   └── mac                  # Scripts to configure macOS settings and preferences
│       ├── finder.sh  
│       └── ...
│
├── plugins
│   ├── zsh                  # Scripts to install ZSH plugins
│   │   ├── oh_my_zsh.sh  
│   │   └── ...
│   └── bash                 # Scripts to install Bash plugins
│       ├── dummy.sh
│       └── ...
└── ...
```

| :bulb: Note |
| :--------------------------------------- |
| For detailed information about the dotfiles repo structure, please [read here](https://zachinachshon.com/dotfiles-cli/docs/latest/usage/structure/). |

<br>

<h3 id="brew">brew</h3>

Declare which Homebrew components to install by type, the brew folder holds the Homebrew components declarations, items on each file should be separated by a new line.

Usage:

```bash
dotfiles brew <packages/casks/drivers/services/all>
```

<br>

<h3 id="dotfiles">dotfiles</h3>

Sync or unsync symlinks from the dotfiles repository and control what to source on an active shell session.

Usage:

```bash
dotfiles sync <home/shell/all>
```

| Domain         | Description 
| :------------------- |:---
| `home` | The dotfiles folder contains files to symlink from the repository to the $HOME folder, an unsync command is available to remove them when necessary.
| `custom`    | Session based content such as  to get sourced on specific machines e.g. work related / personal
| `session`   | Session based content such as `exports`, `aliases`, `functions` to get sourced across all machines on every new shell session.
| `shell`   | Those are shell RC files that get symlinked into the $HOME folder accoridng to the active shell in use (`zsh`/`bash`), those files are being sourced on every new shell session. There is a `dotfiles reload` command available to apply on an active shell session.
| `transient`   | If files in the `transient` folder exists, they will be sourced along but won't get symlinked anywhere. You can use this to export ENV VARs with sensitive information such as secrets to become available on any newly opened shells. Files under `transient` folder are git ignored by default to prevent from committing to a public repository.

| :warning: Warning |
| :--------------------------------------- |
| It is not recommended to commit the `.secrets` transient file as it may contain sensitive information. |

<br>

<h3 id="os">os</h3>

Update OS settings and preferences, the os folder contains scripts that configure the presonal settings and preferences for mac / linux operating systems.

Usage:

```bash
dotfiles os <linux/mac>
```

<br>

<h3 id="plugins">plugins</h3>

Install plugins by shell type, the plugins folder contains scripts to run on a specific shell type.

Usage:

```bash
dotfiles plugins <bash/zsh>
```

<br>

<h3 id="documentation">📖 Documentation</h3>

Please refer to the [documentation](https://zachinachshon.com/dotfiles-cli/docs/latest/getting-started/introduction/) for detailed explanation on how to configure and use `dotfiles-cli`.

<br>

<sup><b>Credits: </b><a href=https://github.com/jglovier/dotfiles-logo>Logo</a> created by <a href=https://github.com/jglovier>Joel Glovier</a></sup>
