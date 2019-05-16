#!/bin/bash
which -s brew
if [[ $? != 0 ]]; then
    echo "Installing Homebrew"
    # Install Homebrew
    # https://github.com/mxcl/homebrew/wiki/installation
    /usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"
else
    echo "Homebrew Upating"
    brew update
fi

#brew install macvim --with-override-system-vim
echo "export DOTFILE_ROOT='$(pwd)'" >> ~/.bash_profile
export DOTFILE_ROOT=$(pwd)

brew tap homebrew/cask-fonts
brew cask install font-dejavusansmono-nerd-font-mono
brew install global
brew install the_silver_searcher
brew install tmux
brew install neovim
brew install zsh
brew install zplug
brew install zsh-completions
brew install reattach-to-user-namespace
brew install python3
brew install python
brew install pipenv
brew install pyenv
brew install pyenv-virtualenv
brew install rlwrap
# git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

pip2 install neovim
pip2 install powerline-status
pip2 install jedi
pip2 install meld3
pip2 install setuptools
pip2 install virtualenv

pip3 install powerline-status
pip3 install jedi
pip3 install neovim

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
