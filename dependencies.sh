#!/usr/bin/env bash

brew install --cask font-fira-code-nerd-font
brew install --cask claude-code

# Shell + editor
brew install starship neovim

# For image support
brew install imagemagick luarocks lua tree-sitter tree-sitter-cli
luarocks --lua-version 5.1 install magick
brew install gnupg pinentry-mac
# to start using pinetree-mac: gpgconf --kill gpg-agent
# you also have to add "pinentry-program /opt/homebrew/bin/pinentry-mac" to ~/.gnupg/gpg-agent.conf
brew install bat eza fd ripgrep zoxide btop dust duf delta gh tlrc fzf atuin

# Used by aliases/functions in .config/anew/anew-init.sh
brew install kubectl mosh coreutils  # coreutils provides greadlink
brew install hashicorp/tap/terraform
