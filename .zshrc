# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="/Users/domev/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql@5.7/bin:$PATH"
export VISUAL="nvim"
export EDITOR="nvim"
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi


# virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Work
source ~/.pyenv/versions/3.11.2/bin/virtualenvwrapper.sh

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

# nnn config
n ()
{
    # Block nesting of nnn in subshells
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    #      NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # The command builtin allows one to alias nnn to n, if desired, without
    # making an infinitely recursive alias
    command nnn -deCH "$@"

    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    }
}

nnn_cd()                                                                                                   
{
    if ! [ -z "$NNN_PIPE" ]; then
        printf "%s\0" "0c${PWD}" > "${NNN_PIPE}" !&
    fi  
}

trap nnn_cd EXIT

export NNN_FIFO="/tmp/nnn.fifo"
export NNN_PLUG='f:fzopen;v:preview-tui'


# fzf config
export FZF_ALT_C_OPTS="--preview 'exa --long --tree --level=1 --git --icons {} | head -200'"
bindkey "^o" "fzf-cd-widget"
bindkey "^q" "fzf-cd-widget"

# config shortcuts
alias cat="bat"
alias t="touch"
alias conf="cd ~/.config"
alias dot="cd ~/Dotfiles"
alias lmda="cd ~/Work/tenspeed-lambda/"

# neovim
alias v="nvim -c \"lcd%:p:h\""
alias src="source ~/.zshrc"
alias zrc="v ~/Dotfiles/.zshrc"
alias nrc="v~/Dotfiles/nvim/init.lua -c \"lcd%:p:h\""
alias wrc="v~/Dotfiles/.wezterm.lua -c \"lcd%:p:h\""
alias krc="v~/Dotfiles/kitty/kitty.conf -c \"lcd%:p:h\""
alias ybrc="v~/Dotfiles/yabai/yabairc -c \"lcd%:p:h\""
alias skrc="v~/Dotfiles/skhd/skhdrc -c \"lcd%:p:h\""

# git & github
alias gmm="git merge master"
alias gupdate="git add . && git commit -m 'Update' && git push"

# exa
alias ls="exa --git"
alias ll="exa -la --git"
alias l="exa -l --git"
alias lg="exa -G --git"
alias lG="exa -aG --git"
alias lt="exa -lT --level=2 --git"
alias lT="exa -laT --level=2  --git"
alias lD="exa -laD --level=2 --git"

# python
alias py="python"
alias dd="deactivate"
alias ipy="ipython"
alias i="ipython"
alias pua="pip uninstall -y -r <(pip freeze)"

# virtualenvs
function cd() {
  builtin cd "$@" && \
  if [[ -n $(ls -aD ~/.virtualenvs | grep $(basename $(pwd))) ]]; then
    workon $(basename $(pwd))
  fi
}
