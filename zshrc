# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export PATH="/opt/homebrew/opt/mysql-client@8.0/bin:$PATH"

source "$HOME/.dotfiles/.api_keys.zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(
    macos
    brew
    git
    zsh-autosuggestions
    zsh-interactive-cd
    aws
    fzf
    tmux
    direnv
    python
    pyenv
    pip
    rust
    docker
    gh
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi
export VISUAL="nvim"

# quick dirs
alias dot="cd ~/.dotfiles/"
alias pr="cd ~/Projects/"
alias 10speed="cd ~/Projects/tenspeed-lambda/"
alias nt="cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Notes/"

# git
alias gp="git pull"
alias gP="git push"

# vim
alias v="nvim"
alias src="source ~/.zshrc"
alias zrc="cd ~/.dotfiles && v zshrc"
alias vrc="cd ~/.dotfiles/nvim/ && v"

# tmux
alias trc="tmux source-file ~/.dotfiles/tmux.conf"
(( $+TMUX )) && unset zle_bracketed_paste
source "$HOME/.dotfiles/tmux-sessions.zsh"


# terminal-notifier
alias tn="terminal-notifier -message \"DONE\" -sound default"

# file listings
function preview_stuff() {
    # If no arguments, fall back to real cat reading stdin
    if [ $# -eq 0 ]; then
        command bat
        return
    fi

    # Check if it's a directory
    if [ -d "$1" ]; then
        eza -l --git -T -L 2 "$1"
        return
    fi

    local img_exts="jpg jpeg png gif bmp tiff svg webp"
    local extension="${1##*.}"
    if [[ " $img_exts " == *" $extension "* ]]; then
        viu "$1" -w 120
    else
        bat "$1"
    fi
}

alias vv="preview_stuff"
alias t="touch"
alias l="eza -l --git"
alias ll="eza -la --git"
alias lt="eza -l --git -T -L 2"
alias llt="eza -l --git -T -L"

# python
alias py="python"
alias ipy="ipython"
alias pua="pip uninstall -y -r <(pip freeze)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"


# The following lines were added by compinstall
# zstyle ':completion:*' completer _complete _ignored
# zstyle :compinstall filename '/Users/domas-v/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

eval "$(starship init zsh)"
