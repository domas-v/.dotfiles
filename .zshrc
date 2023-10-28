# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="/Users/domev/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql@5.7/bin:$PATH"
export VISUAL="code"
export EDITOR="vim"


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
    poetry
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
export FZF_ALT_C_OPTS="--preview 'exa --long --tree --level=1 --git --icons {} | head -200'"
bindkey "^q" "fzf-cd-widget"
bindkey -s "^o" "fzf -m | xargs -o nvim\r"

# config shortcuts
alias t="touch"
alias cat="bat"
alias conf="cd ~/.config"
alias dot="cd ~/Dotfiles"
alias lmda="cd ~/Work/tenspeed-lambda/"
alias notes="cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Notes"
alias qn="nvim ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Notes/Quick\ Note.md"

# universal preview command
function e() {
    if [[ -z "$1" ]]; then
        exa -lT --level=1 --git
    elif [[ "$1" =~ \.(png|jpg|jpeg|gif|bmp|tiff|tif|webp)$ ]]; then
        wezterm imgcat "$1" "${@:2}"
    elif [[ "$1" =~ \.(mp4|mov|mkv|avi|webm)$ ]]; then
        mpv --no-terminal "$1"
    elif [[ -d "$1" ]]; then
        exa -lT --level=1 --git "$1"
    elif [[ "$1" =~ \.(json)$ ]]; then
        jless "$1"
    elif [[ "$1" =~ \.(md)$ ]]; then
        glow "$1"
    else
        bat "$1"
    fi
}

function ee() {
    if [[ -z "$1" ]]; then
        exa -lT --level=2 --git
    elif [[ -d "$1" ]]; then
        exa -lT --level=2 --git "$1"
    else
        bat "$1"
    fi
}

# neovim
alias v="nvim -c \"lcd%:p:h\""
alias src="source ~/.zshrc"
alias vrc="v ~/Dotfiles/.vimrc"
alias zrc="v ~/Dotfiles/.zshrc"
alias nrc="v ~/Dotfiles/nvim/init.lua -c \"lcd%:p:h\""
alias wrc="v ~/Dotfiles/.wezterm.lua -c \"lcd%:p:h\""
alias krc="v ~/Dotfiles/kitty/kitty.conf -c \"lcd%:p:h\""
alias ybrc="v ~/Dotfiles/yabai/yabairc -c \"lcd%:p:h\""
alias skrc="v ~/Dotfiles/skhd/skhdrc -c \"lcd%:p:h\""

# git & github
alias gmm="git merge master"
alias gupdate="git add . && git commit -m 'Update' && git push"

# exa
alias ls="exa --git"
alias l="exa -lT --level=1 --git"
alias ll="exa -laT --level=1 --git"
alias lll="exa -laT --level=2 --git"

# python
alias py="python"
alias ipy="ipython"
alias a="source venv/bin/activate"
alias dd="deactivate"
alias pua="pip uninstall -y -r <(pip freeze)"

# virtualenvs
function cd() {
  builtin cd "$@" && \
  if [[ -e "venv/bin/activate" ]]; then
  	source venv/bin/activate
  fi
}
