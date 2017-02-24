# ~/.bashrc: executed by bash(2) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
if [[ "$OSTYPE" == "darwin"* ]]; then
  if [ -d "/usr/local/opt/coreutils/libexec/gnubin" ]; then
     PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
     MANPATH="/usr/local/opt/coreutils/libexec/gnubin:$MANPATH"
  fi
  # Mac OSX
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
#if [ "$color_prompt" = yes ]; then
   PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]\[\033[01;35m\]@\D{%F~%R~%Z}\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
#else
#   PS1='${debian_chroot:+($debian_chroot)}\u@\h@\d-\A:\w\n\$ '
#fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
   PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
   ;;
*)
   ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoredups:ignorespace:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# write to the history and reload after every command
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

export VISUAL=vim
export EDITOR="$VISUAL"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000000000
HISTFILESIZE=10000000000
HISTIGNORE="&:ls:[bf]g:exit"

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ag='ag --path-to-agignore ~/.agignore'

alias kanyefidence="curl -s http://usatoday30.usatoday.com/exp/kanye/js/kanye.js | head -n 27 | sed -n 's|\[\"\(.*\)\",.*,|\1|p' | shuf | head -n 1"
alias gimme-some-kanyefidence="kanyefidence"
alias ll="ls -al"
alias tmux="~/bin/tmux_common.sh twinlock"
alias docker-ips='docker ps | tail -n +2 | while read -a a; do name=${a[$((${#a[@]}-1))]}; echo -ne "$name\t"; docker inspect $name | grep IPAddress | cut -d \" -f 4; done'
alias docker-cid='docker ps | tail -n +2 | sed -e "s/ .*$//g"'
alias docker-attach='docker attach $(docker-cid)'
alias hls="hadoop fs -ls"
alias hll="hadoop fs -ls"
alias hcp="hadoop fs -cp"
alias hmv="hadoop fs -mv"
alias hu="hadoop fs "
alias gralde="gradle"
alias start_eclim="/Users/tesswinlock/eclipse/java-mars/Eclipse.app/Contents/Eclipse/eclimd -Xmx2048M 2>/dev/null &>/dev/null &"
alias eclim="start_eclim"
alias sqlline="java -Djava.ext.dirs=$HOME/sqlline/  sqlline.SqlLine"
export OOZIE_URL="http://localhost:11000/oozie"
export LANG=en_US.utf8


# The next line updates PATH for the Google Cloud SDK.
if [ -f /Users/tesswinlock/Documents/google-cloud-sdk/path.bash.inc ]; then
  source '/Users/tesswinlock/Documents/google-cloud-sdk/path.bash.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /Users/tesswinlock/Documents/google-cloud-sdk/completion.bash.inc ]; then
  source '/Users/tesswinlock/Documents/google-cloud-sdk/completion.bash.inc'
fi
