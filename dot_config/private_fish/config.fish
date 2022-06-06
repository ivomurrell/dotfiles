# Homebrew
fish_add_path /opt/homebrew/bin
# Rust
fish_add_path ~/.cargo/bin
# Emacs
fish_add_path  ~/.emacs.d/bin

# 1Password
set -gx SSH_AUTH_SOCK "~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"

if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end

# iTerm shell ntegration
test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish ; or true

set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

set -gx EDITOR nvim
