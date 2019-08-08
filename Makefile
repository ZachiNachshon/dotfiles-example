#
#.PHONY: bin
#bin: ## Installs the bin directory files.
#	# add aliases for things in bin
#	for file in $(shell find $(CURDIR)/bin -type f -not -name "*-backlight" -not -name ".*.swp"); do \
#		f=$$(basename $$file); \
#		sudo ln -sf $$file /usr/local/bin/$$f; \
#	done

.PHONY: install
install: ## Create symlink from this repo to $HOME directory
	-@$(CURDIR)/dotfiles/.dotfiles-scripts "--install"

.PHONY: uninstall
uninstall: ## Remove all symlinks from $HOME directory
	-@$(CURDIR)/dotfiles/.dotfiles-scripts "--uninstall"

.PHONY: brew
brew: ## Installs commonly used Homebrew packages and casks
	-@$(CURDIR)/brew/.brew-install

.PHONY: mac
mac: ## Install macOS KeyBindings, setup finder customizations and keyboard preferences
	-@$(CURDIR)/mac/.mac-install

.PHONY: all
all: install brew mac ## Execute `install`, `brew` and `mac` in this order

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


# Need to check before usage
#	ln -snf $(PWD)/.fonts $(HOME)/Library/Fonts;