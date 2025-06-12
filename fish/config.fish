set -g direnv_fish_mode eval_on_arrow

alias ls="eza"
alias tree="eza --tree"
alias cat="bat"
alias cd="z"
alias cdi="zi"

zoxide init fish | source
starship init fish | source
