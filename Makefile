SHELL := /bin/bash
.POSIX:
.PHONY: help install remove

help: ## Show this help
	@grep -E -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install all dotfiles packages
	stow --verbose --target=$$HOME --restow tmux wezterm starship zsh git greenclip picom

remove: ## Remove all dotfiles packages
	stow --verbose --target=$$HOME --delete tmux wezterm starship zsh git greenclip picom