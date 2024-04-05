# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# export VISUAL="code"
# export EDITOR="nvim"


export C_INCLUDE_PATH=/usr/local/include
export LD_LIBRARY_PATH=/usr/local/lib
export LIBRARY_PATH=/usr/local/lib


if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

source "/opt/homebrew/opt/spaceship/spaceship.zsh"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

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
    python
    pyenv
    # poetry
    pip
    gh
    aws
    rust
    docker
    ripgrep
    fd
    fzf
)

source $ZSH/oh-my-zsh.sh

# User configuration

# fzf config
export FZF_DEFAULT_COMMAND='fd . -t f -H -E .git -E venv'
# export FZF_ALT_C_OPTS="--preview 'exa --long --tree --level=1 --git --icons {} | head -200'"
bindkey "^q" "fzf-cd-widget"
bindkey -s "^o" "fzf -m | xargs -o nvim\r"

# config shortcuts
alias t="touch"
alias cat="bat"
alias cl="clear"
alias c="clear"

# navivgation shortcuts
alias dot="cd ~/Dotfiles"
alias pr="cd ~/Projects/"
alias lmda="cd ~/Projects/tenspeed-lambda/"
alias nt="cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Notes"


# neovim
alias v="nvim -c \"lcd%:p:h\""
alias c="code"
alias src="source ~/.zshrc"
alias vrc="v ~/Dotfiles/.vimrc"
alias zrc="v ~/Dotfiles/.zshrc"
alias nrc="v ~/Dotfiles/nvim/init.lua"
alias n="v -c \"lcd%:p:h\" ~/Desktop/Notes/notes.md"
alias krc="v ~/Dotfiles/kitty/kitty.conf"

# git & github
alias lg="lazygit"
alias gmm="git merge master"
alias gsync="git pull && git add . && git commit -m 'Update' && git push"

# eza
alias l="eza -l --git"
alias ll="eza -la --git"

# C
cc50() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: cc50 <path-to-program.c>"
        return 1
    fi

    local source_file="$1"
    local program_name=${source_file%.*}

    if [[ ! -f "$source_file" ]]; then
        echo "Error: $source_file not found."
        return 1
    fi

    clang -g "$source_file" -o "$program_name" -lcs50
}

# python
alias py="python"
alias ipy="ipython"
# alias a="source venv/bin/activate"
alias dd="deactivate"
alias pua="pip uninstall -y -r <(pip freeze)"

# virtualenvs
function cd() {
  builtin cd "$@" && \
  if [[ -e "venv/bin/activate" ]]; then
  	source venv/bin/activate
  fi
}

function a() {
    if [[ "$#" -eq 0 ]]; then
        if [[ -e "venv/bin/activate" ]]; then
            source venv/bin/activate
        else
            echo "No virtual environment here"
        fi
    elif [[ "$#" -eq 1 ]]; then
        conc="$@/venv/bin/activate"
        conc="${conc%/}venv/bin/activate"
        echo $conc
    else
        echo "No virtual environment here"
    fi
}

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

alias gcloud="/Users/domev/Downloads/google-cloud-sdk/bin/gcloud"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/domev/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/domev/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/domev/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/domev/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
