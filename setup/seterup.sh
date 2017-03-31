#!/bin/bash
which -s brew
if [[ $? != 0 ]] ; then
    echo "Installing Homebrew"
    # Install Homebrew
    # https://github.com/mxcl/homebrew/wiki/installation
    /usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"
else
    echo "Homebrew Upating"
    brew update
fi
brew install macvim --with-override-system-vim
echo "export DOTFILE_ROOT='$(pwd)'" >> ~/.bash_profile
echo "source $HOME/.bash_local" >> ~/.bashrc
export DOTFILE_ROOT=$(pwd)

brew install the_silver_searcher
brew install tmux
brew install rlwrap
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

FILE='vimrc'
if [ ! -f "$FILE" ]
then
  ln -sf $DOTFILE_ROOT/vimrc ~/.vimrc
else
  cat $DOTFILE_ROOT/vimrc > $HOME/.vimrc
fi

if [ ! -f "$FILE" ]
then
ln -sf $DOTFILE_ROOT/bashrc ~/.bash_local
else
fi
ln -sf $DOTFILE_ROOT/tmux.conf ~/.tmux.conf
ln -sf $DOTFILE_ROOT/bin ~/tess_bin
chmod -R +x ~/tess_bin
