# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#-----Startup-----#
bash ~/.resources/startup/startup.sh

#-----Path-----#
export ZSH="$HOME/.oh-my-zsh"

#-----Theme-----#
ZSH_THEME="josh" # set by `omz`

#-----Case-Sensitive-Completion-----#
CASE_SENSITIVE="true"

#-----Updates-----#
zstyle ':omz:update' mode disabled
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 13

#-----Auto-Correction-----#
ENABLE_CORRECTION="true"

#-----Waiting-Dots-----#
COMPLETION_WAITING_DOTS="true"

#-----Untrack-Files-----#
DISABLE_UNTRACKED_FILES_DIRTY="true"

#-----History-Stamps-----#
HIST_STAMPS="mm/dd/yyyy"

#-----Plugins-----#
plugins=(git vagrant-prompt cake)
plugins=(git z sudo)

source $ZSH/oh-my-zsh.sh

#-----Language-----#
export LANG=en_US.UTF-8

#-----Preferred-editor-----#
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

#-----Compilation-flags-----#
export ARCHFLAGS="-arch $(uname -m)"

#-----Aliases-----#
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias ls="eza -g -l -H --tree --level 1 --hyperlink"
alias update="brew update"

#-----Custom-----#
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
