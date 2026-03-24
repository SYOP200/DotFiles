set fish_greeting "Hello, SYOP200"

set -gx TERM xterm-256color

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# aliases
alias ls "eza -l --tree --level=1 --icons=always --header"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g "git"
alias c claude
alias claude-yolo "claude --dangerously-skip-permissions"
alias update "brew upgrade"
alias fishconfig "nvim ~/.config/fish/config.fish"
command -qv nvim && alias vim nvim

