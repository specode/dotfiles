#!/usr/bin/env bash

set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

info() {
	printf "${BLUE}==>${NC} %s\n" "$1"
}

success() {
	printf "${GREEN}==>${NC} %s\n" "$1"
}

error() {
	printf "${RED}==>${NC} %s\n" "$1" >&2
}

if [ "$#" -ne 0 ]; then
	error 'Usage: ./install.sh'
	exit 1
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_ROOT="$HOME/.dotfiles-backups/$(date +%Y%m%d%H%M%S)-$$"
backup_created=0

install_homebrew() {
	if command -v brew >/dev/null 2>&1; then
		info "Homebrew already installed"
		return
	fi

	info "Installing Homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	local brew_path
	for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew; do
		if [ -x "$brew_path" ]; then
			eval "$("$brew_path" shellenv)"
			break
		fi
	done

	if ! command -v brew >/dev/null 2>&1; then
		error "Homebrew installation did not complete"
		exit 1
	fi
}

install_config() {
	local repository_path="$1"
	local home_path="$2"
	local source_path="$DOTFILES_DIR/$repository_path"
	local target_path="$HOME/$home_path"
	local backup_path="$BACKUP_ROOT/$home_path"
	local temporary_path

	if [ ! -f "$source_path" ] || [ -L "$source_path" ]; then
		error "Invalid repository file: $source_path"
		exit 1
	fi

	if [ -e "$target_path" ] && [ ! -L "$target_path" ] && [ -f "$target_path" ] && cmp -s "$source_path" "$target_path"; then
		info "Already up to date: $target_path"
		return
	fi

	mkdir -p "$(dirname "$target_path")"
	temporary_path="$(mktemp "$(dirname "$target_path")/.dotfiles-install.XXXXXX")"
	cp -p "$source_path" "$temporary_path"

	if [ -e "$target_path" ] || [ -L "$target_path" ]; then
		mkdir -p "$(dirname "$backup_path")"
		mv "$target_path" "$backup_path"
		backup_created=1
	fi

	if ! mv -f "$temporary_path" "$target_path"; then
		if [ -e "$backup_path" ] || [ -L "$backup_path" ]; then
			mv "$backup_path" "$target_path"
		fi
		error "Could not install: $target_path"
		exit 1
	fi

	success "Installed $target_path"
}

install_homebrew

info "Installing terminal tools and applications"
brew bundle --file="$DOTFILES_DIR/terminal/Brewfile"

install_config 'terminal/ghostty/config' '.config/ghostty/config'
install_config 'terminal/starship/starship.toml' '.config/starship.toml'
install_config 'terminal/zsh/.zshrc' '.zshrc'
install_config 'terminal/zsh/.zsh_plugins.txt' '.zsh_plugins.txt'

if [ "$backup_created" -eq 1 ]; then
	info "Previous configuration saved under $BACKUP_ROOT"
fi

success "Installation complete"
