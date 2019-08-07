.PHONY: all
all: install brew mac ## Installs everyting
#
#.PHONY: bin
#bin: ## Installs the bin directory files.
#	# add aliases for things in bin
#	for file in $(shell find $(CURDIR)/bin -type f -not -name "*-backlight" -not -name ".*.swp"); do \
#		f=$$(basename $$file); \
#		sudo ln -sf $$file /usr/local/bin/$$f; \
#	done

.PHONY: uninstall
uninstall: ## Installs the dotfiles
	-@$(CURDIR)/dotfiles/.dotfiles-scripts "--uninstall"

.PHONY: install
install: ## Installs the dotfiles
	-@$(CURDIR)/dotfiles/.dotfiles-scripts "--install"

.PHONY: brew
homebrew: ## Installs homebrew packages and casks
	-@$(CURDIR)/brew/.brew-install

.PHONY: mac
mac-install: ## Installs MAC OSx defaults & key bindings
	-@$(CURDIR)/mac/.mac-install

# Need to check before usage
#	ln -snf $(PWD)/.fonts $(HOME)/Library/Fonts;