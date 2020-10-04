default: help

.PHONY: dotfiles
dotfiles: ## Create symlinks from this repo to $HOME directory
	-@$(CURDIR)/dotfiles/dotfiles-scripts.sh "--install"

.PHONY: dotfiles-uninstall
dotfiles-uninstall: ## Remove all symlinks from $HOME directory
	-@$(CURDIR)/dotfiles/dotfiles-scripts.sh "--uninstall"

.PHONY: brew
brew: ## Installs commonly used Homebrew packages and casks
	-@$(CURDIR)/brew/brew-install.sh

.PHONY: mac
mac: ## Install macOS KeyBindings, setup finder customizations and keyboard preferences
	-@$(CURDIR)/mac/.mac-install

.PHONY: all
all: install brew mac ## Execute `install`, `brew` and `mac` in this order

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'