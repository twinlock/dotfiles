#!/bin/bash
install_cmd=""
platform=""
echo "export DOTFILE_ROOT='$(pwd)'" >>~/.bash_profile
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
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
      echo "Homebrew Upating"
      brew update
    fi
    brew tap homebrew/cask-fonts
    brew install --cask font-dejavu-sans-mono-nerd-font
    brew install --cask font-roboto-mono-nerd-font
    #brew install the_silver_searcher
    #brew install reattach-to-user-namespace
    # unity/c# dev: roslyn LS needs the dotnet sdk; toolbox manages rider
    brew install --cask dotnet-sdk
    brew install --cask jetbrains-toolbox
    # terminal
    brew install --cask ghostty
    # vim helpers
    brew install lua
    brew install luarocks
    brew install fd
    brew install rust
    brew install python@3.12
  fi
elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
  # we assume debian
  install_cmd="sudo apt install"
  platform="Linux"
  read -p "Install Fonts?" -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # font install
    mkdir -p "$HOME/.fonts"
    fon_list=("OpenDyslexic" "DejaVuSansMono" "Noto")
    for font_name in "${fon_list[@]}"; do
      curl -OL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font_name.zip"
      mv "$font_name.zip" /tmp/
      unzip "/tmp/$font_name.zip" -d "$HOME/.fonts/$font_name/"
    done
    fc-cache -fv
  fi
  read -p "Update Inotify instances (required for unity dev)?" -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo 'fs.inotify.max_user_instances = 1024' | sudo tee /etc/sysctl.d/60-inotify.conf && sudo sysctl --system
  fi
  sudo apt install python3-venv
elif [[ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]]; then
  echo "setup script doesn't work on windows"
  exit 0
elif [[ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]]; then
  echo "setup script doesn't work on windows"
  exit 0
fi
read -p "Perform installations?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Continuing"

  $install_cmd tmux
  $install_cmd neovim
  $install_cmd zsh
  $install_cmd zsh-completions
  $install_cmd rlwrap
  $install_cmd ripgrep
  $install_cmd imagemagick
  # unity/c# dev: roslyn LS needs the dotnet sdk (mac gets it via brew cask above)
  # rider itself comes from the jetbrains toolbox app: mac via brew cask above,
  # linux has no clean apt path - grab the tarball from jetbrains.com/toolbox-app
  if [[ "$platform" == "Linux" ]]; then
    $install_cmd dotnet-sdk-9.0
    # terminal (mac gets it via brew cask above). ghostty has no ubuntu/mint repo
    # pre-26.04; this is the installer ghostty.org officially links (handles mint)
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
  fi

  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  git lfs install
fi

function link_rc_local() {
  FILE=$1
  [[ ! -f "$HOME/.${FILE}_local" ]] && ln -sf "$DOTFILE_ROOT/${FILE}" ~/.${FILE}_local
  echo "source $HOME/.${FILE}_local" >>~/.$FILE
}

function link_rc() {
  FILE=$1
  if [[ ! -f "$HOME/$FILE" ]]; then
    ln -sf "$DOTFILE_ROOT/$FILE" ~/.$FILE
  else
    cat "$DOTFILE_ROOT/$FILE" >$HOME/.$FILE
  fi
}

read -p "Add Git Configs?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  read -p "What's your email?" -r
  git config --global user.email $REPLY
  git config --global core.autocrlf input
  git config --global --add alias.pushu '!git push -u origin $(git symbolic-ref --short HEAD)'
  git config --global --add alias.track '!git branch --set-upstream-to=origin/`git symbolic-ref --short HEAD`'
fi

read -p "Perform Linking?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  # git autocomplete
  curl -o ~/.zsh/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
  curl -o ~/.zsh/_git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
  rm ~/.zcompdump
  link_rc_local bashrc
  link_rc_local zshrc
  link_rc vimrc
  # rider (and other jetbrains ides) read vim bindings from ~/.ideavimrc
  link_rc ideavimrc
  # mkdir -p $HOME/.config/nvim/
  # mkdir -p $HOME/.config/nvim/lua/
  # ln -sf "$DOTFILE_ROOT/config/nvim/init.vim" $HOME/.config/nvim/init.vim
  # ln -sf "$DOTFILE_ROOT/config/nvim/keymap.vim" $HOME/.config/nvim/keymap.vim
  # ln -sf "$DOTFILE_ROOT/config/nvim/plugins.vim" $HOME/.config/nvim/plugins.vim
  # ln -sf "$DOTFILE_ROOT/config/nvim/lua/keymap.lua" $HOME/.config/nvim/lua/keymap.lua
  # ln -sf "$DOTFILE_ROOT/config/nvim/lua/plugins.lua" $HOME/.config/nvim/lua/plugins.lua
  ln -sf "$DOTFILE_ROOT/config/nvim/" $HOME/.config/nvim
  ln -sf "$DOTFILE_ROOT/config/powerline" $HOME/.config/powerline
  ln -sfn "$DOTFILE_ROOT/config/ghostty" $HOME/.config/ghostty
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
  echo "You'll probobaly need to open a new terminal, then run zplug install"
fi
