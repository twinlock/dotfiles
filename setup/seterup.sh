#!/bin/bash
install_cmd=""
platform=""
echo "export DOTFILE_ROOT='$(pwd)'" >> ~/.bash_profile
export DOTFILE_ROOT=$(pwd)
if [[ "$(uname)" == "Darwin" ]]; then
    # Do something under Mac OS X platform        
    install_cmd="brew install"
    platform="Mac"
    read -p "Install brew and mac specific stuff?" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
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
        brew tap homebrew/cask-fonts
        brew install --cask font-dejavu-sans-mono-nerd-font
        brew install --cask font-roboto-mono-nerd-font
        brew install the_silver_searcher
        brew install reattach-to-user-namespace
    fi
elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
    # we assume debian
    install_cmd="apt install"
    platform="Linux"
    read -p "Install Fonts?" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # font install
        mkdir -p  "$HOME/.fonts";
        fon_list=("OpenDyslexic" "DejaVuSansMono" "Noto")
        for font_name in "${fon_list[@]}"; do
    	    curl -OL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font_name.zip"
	    mv "$font_name.zip" /tmp/
            unzip "/tmp/$font_name.zip" -d "$HOME/.fonts/$font_name/"
        done
        fc-cache -fv
    fi
elif [[ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]]; then
    echo "setup script doesn't work on windows"
    exit 0
elif [[ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]]; then
    echo "setup script doesn't work on windows"
    exit 0
fi
read -p "Perform installations?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Continuing"
    
    $install_cmd tmux
    $install_cmd neovim
    $install_cmd zsh
    $install_cmd zsh-completions
    $install_cmd rlwrap
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi



function link_rc_local() {
  FILE=$1
  [[ ! -f "$HOME/.${FILE}_local" ]] && ln -sf "$DOTFILE_ROOT/${FILE}" ~/.${FILE}_local
  echo "source $HOME/.${FILE}_local" >> ~/.$FILE
}

function link_rc() {
  FILE=$1
  if [[  ! -f "$HOME/$FILE" ]]; then
    ln -sf "$DOTFILE_ROOT/$FILE" ~/.$FILE
  else
    cat "$DOTFILE_ROOT/$FILE" > $HOME/.$FILE
  fi
}

read -p "Perform Linking?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # git autocomplete
    curl -o ~/.zsh/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
    curl -o ~/.zsh/_git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
    rm ~/.zcompdump
    link_rc_local bashrc
    link_rc_local zshrc
    link_rc vimrc
    mkdir -p $HOME/.config/nvim/
    mkdir -p $HOME/.config/nvim/lua/
    ln -sf "$DOTFILE_ROOT/config/nvim/init.vim" $HOME/.config/nvim/init.vim
    ln -sf "$DOTFILE_ROOT/config/nvim/keymap.vim" $HOME/.config/nvim/keymap.vim
    ln -sf "$DOTFILE_ROOT/config/nvim/plugins.vim" $HOME/.config/nvim/plugins.vim
    ln -sf "$DOTFILE_ROOT/config/nvim/lua/keymap.lua" $HOME/.config/nvim/lua/keymap.lua
    ln -sf "$DOTFILE_ROOT/config/nvim/lua/plugins.lua" $HOME/.config/nvim/lua/plugins.lua
    ln -sf "$DOTFILE_ROOT/config/powerline" $HOME/.config/powerline
    ln -sf "$DOTFILE_ROOT/tmux.conf" ~/.tmux.conf
    ln -sf "$DOTFILE_ROOT/aliases" ~/.aliases
    ln -sf "$DOTFILE_ROOT/bin" ~/tess_bin
    chmod -R +x ~/tess_bin
fi
read -p "Make ZSH the default?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
    # make zsh the default
    sudo sh -c "echo $(which zsh) >> /etc/shells"
    chsh -s $(which zsh)
    zsh
    zplug install
fi
