# Autoload functions
autoload -Uz vcs_info
autoload -U colors && colors



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

### Aliases
alias note='$ZETTELKASTEN/note'

## Git aliases
alias ga='git add'
alias gd='git diff'
alias gc='git commit --verbose'
alias gl1='git log -1 -p'
alias gl='git log --pretty="format:%C(auto)%h %s - %Cred%an, %ad%C(auto) %(decorate)%Creset" --branches --graph --relative-date'

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
