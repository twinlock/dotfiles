export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# plugins {
  # Make sure to use double quotes
  zplug "zplug/zplug", hook-build:"zplug --self-manage"
  zplug "zsh-users/zsh-history-substring-search"
  zplug "powerline/powerline"
  zplug "zsh-users/zsh-autosuggestions"
  zplug "powerline/powerline", use:"powerline/bindings/zsh/powerline.zsh"
  # ^^ for some odd reason it didnt like this unless i removed the use command first
  # zsh-syntax-highlighting must be loaded
  # after executing compinit command and sourcing other plugins
  # (If the defer tag is given 2 or above, run after compinit command)
  zplug "zsh-users/zsh-syntax-highlighting", defer:2
#}

[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
[[ -f "$HOME/.localaliases" ]] && source "$HOME/.localaliases"


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# configure ruby {
  if [[ -d "$HOME/.rvm" ]]; then
    export PATH="$PATH:$HOME/.rvm/bin"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  fi
# }

# configure python {
  export PY_SITE_PACKAGE="$(/usr/local/Cellar/python@3.8/3.8.12/bin/python3 -m site | grep /usr/local/lib | sed -e "s/^ *\'\(.*\)\',/\1/")"
  if which pyenv > /dev/null; then
    eval "$(pyenv init -)";
    eval "$(pyenv virtualenv-init -)"
    export PYENV_ROOT="$(pyenv root)"
  fi
# }

if [[ -d "$PY_SITE_PACKAGE/powerline/" ]]; then
  export POWERLINE_ROOT="$PY_SITE_PACKAGE/powerline/"
  echo "starting powerline daemon"
  powerline-daemon -q
fi

HISTSIZE=10000000
SAVEHIST=10000000
export HISTFILE=~/.zhistory   # History savefile location
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.
export EDITOR=nvim
export VISUAL=nvim

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search


### make keys not suck on mac
bindkey -e
backward-kill-dir () {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
}
zle -N backward-kill-dir
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
bindkey '^[[1;5D' beginning-of-line
bindkey '^[[1;5C' end-of-line
bindkey "^[^[[D" backward-word
bindkey "^[^[[C" forward-word
bindkey "^w" backward-kill-dir
zplug load

# Bloody gcloud commands
# {
  # set the python version, this will require creating pyenv virtualenv 2.7.16 gcloud
  if [[ -d "$PYENV_ROOT/versions/gcloud" ]]; then
    export CLOUDSDK_PYTHON="$PYENV_ROOT/versions/gcloud/bin/python"
    export CLOUDSDK_PYTHON_SITEPACKAGES=0
  fi
  # The next line updates PATH for the Google Cloud SDK.
  if [ -f '/Users/tess/Applications/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/tess/Applications/google-cloud-sdk/path.zsh.inc'; fi

  # The next line enables shell command completion for gcloud.
  if [ -f '/Users/tess/Applications/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/tess/Applications/google-cloud-sdk/completion.zsh.inc'; fi
# }

# Handy Gradle things
# {
  function upfind() {
    dir=`pwd`
    while [ "$dir" != "/" ]; do
      p=`find "$dir" -maxdepth 1 -name $1`
      if [ ! -z $p ]; then
        echo "$p"
        return
      fi
      dir=`dirname "$dir"`
    done
  }

  function gw() {
    GW="$(upfind gradlew)"
    if [ -z "$GW" ]; then
      echo "Gradle wrapper not found."
    else
      "$GW" -p $(dirname "$GW") --profile $@
    fi
  }

  alias killd='jps | grep Daemon | cut -d'\'' '\'' -f1 | xargs kill -9'
# }

zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

autoload -Uz compinit && compinit
