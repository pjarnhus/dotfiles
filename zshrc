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

export PATH="$HOME/miniconda/bin:$PATH"

export PATH="$HOME/.poetry/bin:$PATH"

if [ ! -e "~/.config/zettelkasten-path" ]; then
    find / -type d -name 'zettelkasten' 2> /dev/null | head -n 1 > ~/.config/zettelkasten-path
fi
export ZETTELKASTEN=$(cat ~/.config/zettelkasten-path)
alias zk='xfce4-terminal --tab --working-directory=$ZETTELKASTEN; firefox http://localhost:1313/zettelkasten 2> /dev/null&; cd $ZETTELKASTEN; hugo serve'
alias note='$ZETTELKASTEN/note'
alias blog='$BLOG/blog'
export EDITOR=nvim
export GIT_EDITOR=$EDITOR
