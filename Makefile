default: help

.PHONY: dotfiles
dotfiles: ## Create/remove symlinks in/from folder [$HOME/.dotfiles]
	-@$(CURDIR)/dotfiles/dotfiles.sh

.PHONY: brew
brew: ## Installs commonly used Homebrew packages and casks
	-@$(CURDIR)/brew/brew.sh

.PHONY: mac
mac: ## Install macOS KeyBindings, setup finder customizations and keyboard preferences
	-@$(CURDIR)/mac/mac-os.sh

.PHONY: all
all: mac brew dotfiles  ## Execute `mac`, `brew` and `dotfiles` in this order

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'