#!/usr/bin/env bash

brew install --cask font-fira-code-nerd-font

# For image support
brew install imagemagick luarocks lua tree-sitter
luarocks --lua-version 5.1 install magick
brew install pinentry-mac
# to start using pinetree-mac: gpgconf --kill gpg-agent
# you also have to add "pinentry-program /opt/homebrew/bin/pinentry-mac" to ~/.gnupg/gpg-agent.conf
brew install bat eza fd ripgrep zoxide btop dust duf delta gh tldr fzf atuin
