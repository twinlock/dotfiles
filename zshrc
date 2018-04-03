export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# plugins {
  # Make sure to use double quotes
  zplug "zplug/zplug", hook-build:"zplug --self-manage"
  zplug "zsh-users/zsh-history-substring-search"
  zplug "powerline/powerline"
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
  export PY_SITE_PACKAGE="$(python -m site --user-site)"
  if which pyenv > /dev/null; then
    eval "$(pyenv init -)";
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

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
zplug load

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tess/Downloads/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/tess/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tess/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/tess/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
