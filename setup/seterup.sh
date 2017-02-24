#!/bin/bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install macvim --with-override-system-vim


brew install the_silver_searcher
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

ln -sf ~/Box\ Sync/home/bash_history ~/.bash_history
ln -sf ~/Box\ Sync/home/vimrc ~/.vimrc
ln -sf ~/Box\ Sync/home/bashrc ~/.bashrc
ln -sf ~/Box\ Sync/home/tmux.conf ~/.tmux.conf
ln -sf ~/Box\ Sync/home/inputrc ~/.inputrc
ln -sf ~/Box\ Sync/home/bin ~/bin
chmod -R +x ~/bin
brew install gradle

mkdir ~/.gradle/
echo "org.gradle.daemon=true" >> ~/.gradle/gradle.properties
echo "source ~/.bashrc" >> ~/.profile
echo "export JAVA_HOME=$(/usr/libexec/java_home -v1.8)" >> ~/.profile
