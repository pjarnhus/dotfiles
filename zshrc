# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="kolo"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

export PATH="$HOME/miniconda/bin:$PATH"

export PATH="$HOME/.poetry/bin:$PATH"

export ZETTELKASTEN="/home/phigit/zettelkasten"
export BLOG="/home/phigit/Documents/Misc_Projects/DataScienceTidbits"
alias zk='xfce4-terminal --tab --working-directory=$ZETTELKASTEN; firefox http://localhost:1313/zettelkasten 2> /dev/null&; cd $ZETTELKASTEN; hugo serve'
alias note='$ZETTELKASTEN/note'
alias blog='$BLOG/blog'
export EDITOR=nvim
export GIT_EDITOR=$EDITOR
