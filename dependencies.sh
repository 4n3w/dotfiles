#!/usr/bin/env bash

brew install --cask font-fira-code-nerd-font
brew install fzf
brew install fd

# For image support
brew install imagemagick
brew install luarocks lua
luarocks --lua-version 5.1 install magick
brew install ripgrep
brew install tree-sitter
#brew install pinetree-mac
brew install pinentry-mac
# to start using pinetree-mac: gpgconf --kill gpg-agent
