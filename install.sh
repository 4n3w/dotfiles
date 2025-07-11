#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux) echo "linux" ;;
        *) echo "unknown" ;;
    esac
}

declare -a COMMON_FILES=(
    ".tmux.conf"
    ".vimrc"
)

declare -a MACOS_FILES=(
)

declare -a LINUX_FILES=(
    ".Xresources"
    ".Xresources-template"
    ".Xresources-theme-catppuccin-mocha"
    ".Xresources-theme-nord"
    ".Xresources-theme-rose-pine"
)

declare -a COMMON_CONFIG_DIRS=(
    ".config/atuin"
    ".config/nvim"
    ".config/starship.toml"
    ".config/anew"
)

declare -a LINUX_CONFIG_DIRS=(
    ".config/i3"
    ".config/i3status"
)

declare -a EXECUTABLE_FILES=(
    "theme"
)

print_status() {
    local status="$1"
    local message="$2"
    
    case "$status" in
        "success")
            echo -e "${GREEN}✓${RESET} $message"
            ;;
        "skip")
            echo -e "${YELLOW}⊝${RESET} $message"
            ;;
        "error")
            echo -e "${RED}✗${RESET} $message"
            ;;
        "info")
            echo -e "${BLUE}ℹ${RESET} $message"
            ;;
    esac
}

create_symlink() {
    local source="$1"
    local target="$2"
    local is_executable="${3:-false}"
    
    if [[ -e "$target" || -L "$target" ]]; then
        if [[ -L "$target" ]]; then
            local current_source
            current_source=$(readlink "$target")
            if [[ "$current_source" == "$source" ]]; then
                print_status "skip" "$target already linked to correct source"
            else
                print_status "skip" "$target exists (symlink to: $current_source)"
            fi
        else
            print_status "skip" "$target exists ($(file -b "$target" | cut -d',' -f1))"
        fi
        return 1
    else
        # Create parent directory if it doesn't exist
        local target_dir
        target_dir=$(dirname "$target")
        if [[ ! -d "$target_dir" ]]; then
            mkdir -p "$target_dir"
        fi
        
        if ln -sf "$source" "$target"; then
            if [[ "$is_executable" == "true" ]]; then
                print_status "success" "$target → $source (executable)"
            else
                print_status "success" "$target → $source"
            fi
            return 0
        else
            print_status "error" "Failed to create symlink: $target"
            return 1
        fi
    fi
}

install_config_dir() {
    local config_path="$1"
    local source="$DOTFILES_DIR/$config_path"
    local target="$HOME/$config_path"
    local created=0
    local skipped=0
    
    # Handle single file configs (like starship.toml)
    if [[ -f "$source" ]]; then
        if create_symlink "$source" "$target"; then
            created=$((created + 1))
        else
            skipped=$((skipped + 1))
        fi
        return
    fi
    
    # Handle directory configs
    if [[ ! -d "$source" ]]; then
        print_status "error" "Source not found: $source"
        return
    fi
    
    # If target exists and is not a symlink, skip it
    if [[ -e "$target" && ! -L "$target" ]]; then
        print_status "skip" "$target exists (not a symlink)"
        skipped=$((skipped + 1))
        return
    fi
    
    # Create symlink for the entire directory
    if create_symlink "$source" "$target"; then
        created=$((created + 1))
    else
        skipped=$((skipped + 1))
    fi
}

install_dotfiles() {
    local os_type="$1"
    local -a files_to_link=()
    local -a configs_to_link=()
    local created=0
    local skipped=0
    
    # Determine which files to link
    files_to_link+=("${COMMON_FILES[@]}")
    
    case "$os_type" in
        "macos")
            if [[ ${#MACOS_FILES[@]} -gt 0 ]]; then
                files_to_link+=("${MACOS_FILES[@]}")
            fi
            ;;
        "linux")
            files_to_link+=("${LINUX_FILES[@]}")
            ;;
    esac
    
    # Determine which config directories to link
    configs_to_link+=("${COMMON_CONFIG_DIRS[@]}")
    
    case "$os_type" in
        "linux")
            configs_to_link+=("${LINUX_CONFIG_DIRS[@]}")
            ;;
    esac
    
    echo
    print_status "info" "Installing dotfiles for $os_type..."
    echo
    
    # Install regular dotfiles
    for file in "${files_to_link[@]}"; do
        local source="$DOTFILES_DIR/$file"
        local target="$HOME/$file"
        
        if [[ -f "$source" ]]; then
            if create_symlink "$source" "$target"; then
                created=$((created + 1))
            else
                skipped=$((skipped + 1))
            fi
        else
            print_status "error" "Source file not found: $source"
        fi
    done
    
    echo
    print_status "info" "Installing config directories..."
    echo
    
    # Install config directories
    for config in "${configs_to_link[@]}"; do
        install_config_dir "$config"
        # Update counts based on result
        if [[ $? -eq 0 ]]; then
            created=$((created + 1))
        else
            skipped=$((skipped + 1))
        fi
    done
    
    echo
    print_status "info" "Installing executable scripts to ~/bin..."
    echo
    
    mkdir -p "$HOME/bin"
    
    # Install executable scripts
    for script in "${EXECUTABLE_FILES[@]}"; do
        local source="$DOTFILES_DIR/$script"
        local target="$HOME/bin/$script"
        
        if [[ -f "$source" ]]; then
            if create_symlink "$source" "$target" "true"; then
                created=$((created + 1))
            else
                skipped=$((skipped + 1))
            fi
        else
            print_status "error" "Source script not found: $source"
        fi
    done
    
    echo
    echo "Summary:"
    print_status "info" "Created: $created symlinks"
    print_status "info" "Skipped: $skipped existing files/directories"
    
    # OS-specific post-install messages
    if [[ "$os_type" == "linux" ]] && [[ $created -gt 0 ]]; then
        echo
        print_status "info" "Linux-specific notes:"
        print_status "info" "- To apply X resources: xrdb -merge ~/.Xresources"
        print_status "info" "- To use theme switcher: ~/bin/theme"
        print_status "info" "- i3 config installed at ~/.config/i3/"
        print_status "info" "- i3status config installed at ~/.config/i3status/"
    fi
    
    # General post-install messages
    if [[ $created -gt 0 ]]; then
        echo
        print_status "info" "General notes:"
        if [[ -d "$HOME/.config/nvim" || -L "$HOME/.config/nvim" ]]; then
            print_status "info" "- Neovim config installed. Run nvim to install plugins."
        fi
        if [[ -f "$HOME/.config/starship.toml" || -L "$HOME/.config/starship.toml" ]]; then
            print_status "info" "- Starship prompt config installed."
        fi
        if [[ -d "$HOME/.config/anew" || -L "$HOME/.config/anew" ]]; then
            print_status "info" "- Anew config installed (mysterious!)."
        fi
    fi
    
    if [[ ! "$PATH" =~ $HOME/bin ]]; then
        echo
        print_status "info" "Add ~/bin to your PATH to use installed scripts:"
        print_status "info" "export PATH=\"\$HOME/bin:\$PATH\""
    fi
}

main() {
    echo "Dotfiles Installer"
    echo "=================="
    
    local os_type
    os_type=$(detect_os)
    
    if [[ "$os_type" == "unknown" ]]; then
        print_status "error" "Unsupported operating system: $(uname -s)"
        exit 1
    fi
    
    print_status "info" "Detected OS: $os_type"
    print_status "info" "Dotfiles directory: $DOTFILES_DIR"
    
    install_dotfiles "$os_type"
}

main "$@"
