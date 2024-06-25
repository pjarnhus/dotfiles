# Autoload functions
autoload -Uz vcs_info
autoload -U colors && colors

# Install plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Load completions
autoload -Uz compinit && compinit

zstyle ':vcs_info:*' stagedstr '%F{green}●'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:svn:*' branchformat '%b'
zstyle ':vcs_info:svn:*' formats ' [%b%F{1}:%F{11}%i%c%u%B%F{green}]'
zstyle ':vcs_info:*' enable git svn

theme_precmd () {
  if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    zstyle ':vcs_info:git:*' formats ' [%b%c%u%B%F{green}]'
  else
    zstyle ':vcs_info:git:*' formats ' [%b%c%u%B%F{red}●%F{green}]'
  fi

  vcs_info
}

# Enable parameter expansion
setopt prompt_subst

# Set prompt
# %B = Bold face
# %F = Front colour
# %c = trailing component of working directory
# %# = Returns # if running in privileged mode, % otherwise

PROMPT='%B%F{magenta}%c%B%F{green}${vcs_info_msg_0_}%B%F{magenta} %{$reset_color%}%# '

autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd

### Environment variables
# Set path to Zettelkasten
if [ -f ~/.config/zettelkasten-path ]; then
    export ZETTELKASTEN=$(cat ~/.config/zettelkasten-path)
else
    echo "No path file found for Zettelkasten"
fi
export PATH="$HOME/.poetry/bin:$PATH"
export EDITOR=nvim
export GIT_EDITOR=$EDITOR

### Key bindings
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

### History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

# Append to history file
setopt append_history

# Share history across sessions - adds commands to history file as the are executed
setopt share_history

# Commands starting with a blank space are not added to the history
setopt hist_ignore_space
# Do not store or show duplicate commands in history file
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

### Aliases
alias note='$ZETTELKASTEN/note'
alias ls='ls --color'
alias v=nvim

## Git aliases
alias ga='git add'
alias gd='git diff'
alias gc='git commit --verbose'
alias gp='git push origin HEAD' # Using HEAD results in current branch being pushed
alias gss='git status -sb'
alias gl1='git log -1 -p'
alias gl='git log --pretty="format:%C(auto)%h %s - %Cblue%an, %ad%C(auto) %d%Creset" --branches --graph --relative-date'

# Function for cleaning up local branches after merging a pull request
function gcl(){
    if [ -n "$1" ]
    then
        git checkout master
        git pull origin master
        git remote prune origin
        git branch -d "$1"
    fi
}
