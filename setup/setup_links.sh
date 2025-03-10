export DOTFILE_ROOT=$(pwd)
function link_rc_local() {
  FILE=$1
  [[ ! -f "$HOME/.${FILE}_local" ]] && ln -sf $DOTFILE_ROOT/${FILE} ~/.${FILE}_local
  echo "source $HOME/.${FILE}_local" >> ~/.$FILE
}

function link_rc() {
  FILE=$1
  if [[  ! -f "$HOME/$FILE" ]]; then
    ln -sf $DOTFILE_ROOT/$FILE ~/.$FILE
  else
    cat $DOTFILE_ROOT/$FILE > $HOME/.$FILE
  fi
}

link_rc_local bashrc
link_rc_local zshrc
link_rc ideavimrc
link_rc vimrc
mkdir -p $HOME/.config/nvim/
ln -sf $DOTFILE_ROOT/config/nvim/* $HOME/.config/nvim
ln -sf $DOTFILE_ROOT/config/powerline $HOME/.config/powerline
ln -sf $DOTFILE_ROOT/tmux.conf ~/.tmux.conf
ln -sf $DOTFILE_ROOT/aliases ~/.aliases
ln -sf $DOTFILE_ROOT/bin ~/tess_bin
chmod -R +x ~/tess_bin
# make zsh the default
sudo sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)
zsh
zplug install
