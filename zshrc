if [[ "$(uname)" == "Darwin" ]]; then
  export ZPLUG_HOME=/opt/homebrew/opt/zplug
else
  export ZPLUG_HOME=$HOME/.zplug/
fi
source $ZPLUG_HOME/init.zsh

# Allow more open files than the OSX default of 256
if [ `ulimit -n` -lt 8192 ]; then
    ulimit -n 8192
fi
# plugins {
  # Make sure to use double quotes
  zplug "zplug/zplug", hook-build:"zplug --self-manage"
  zplug "zsh-users/zsh-history-substring-search"
  zplug "zsh-users/zsh-autosuggestions"
  zplug "romkatv/powerlevel10k", as:theme, depth:1
  # zsh-syntax-highlighting must be loaded
  # after executing compinit command and sourcing other plugins
  # (If the defer tag is given 2 or above, run after compinit command)
  zplug "zsh-users/zsh-syntax-highlighting", defer:2
#}

[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
[[ -f "$HOME/.localaliases" ]] && source "$HOME/.localaliases"


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
#if [[ "$(uname)" == "Darwin" ]]; then
  bindkey "^[[A" up-line-or-beginning-search # Up
  bindkey "^[[B" down-line-or-beginning-search # Down
  bindkey '^[[1;5D' beginning-of-line
  bindkey '^[[1;5C' end-of-line
  bindkey "^[^[[D" backward-word
  bindkey "^[^[[C" forward-word
  bindkey "^w" backward-kill-dir
#fi
zplug load

zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

typeset -U path PATH

autoload -Uz compinit && compinit

if [ -d "$HOME/bin/" ]; then
  export PATH="$PATH:$HOME/bin/"
fi

