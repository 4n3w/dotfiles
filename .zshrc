# Homebrew (Apple Silicon / Intel) — needed so starship etc. are on PATH
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH="$HOME/bin:$PATH"

# Opt-in tmux: a terminal launched with START_TMUX=1 in its environment (the
# Hammerspoon menu bar ghost does this) goes straight into the shared "main"
# tmux session. $TMUX guards the shells that tmux itself starts.
if [[ -n "$START_TMUX" && -z "$TMUX" ]] && command -v tmux >/dev/null; then
    exec tmux new-session -A -s main
fi

# SDKMAN — must load BEFORE anew-init.sh. zsh expands aliases inside sourced
# files, so anew's `alias find='fd'` (and grep→rg, cat→bat, ...) would break
# sdkman-init.sh. Nothing below touches the JDK on PATH, so it still wins.
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Aliases, functions, env
[[ -f "$HOME/.config/anew/anew-init.sh" ]] && source "$HOME/.config/anew/anew-init.sh"

# Machine-local settings and secrets (e.g. GEMFIRE_*) live in ~/.zshrc.local,
# outside this public repo. Never put credentials in this file.
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Always use the default (emacs) line-editing keys: Ctrl-A/E/U/K and friends.
# A shell that inherits EDITOR=nvim (a tmux pane, a nested zsh) would otherwise
# start in zsh's vi keymap, where those keys do nothing.
bindkey -e

# Prompt and shell integrations (skipped if the tool isn't installed)
command -v starship >/dev/null && eval "$(starship init zsh)"
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
# --disable-ai: atuin's `?` AI mode sends prompts to the hosted Atuin Hub, so
# keep it off. Older atuin versions don't know the flag; fall back to plain init.
command -v atuin >/dev/null && eval "$(atuin init zsh --disable-ai 2>/dev/null || atuin init zsh)"
