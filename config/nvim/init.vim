:lua require('plugins')
:lua require('keymap')
" source ~/.config/nvim/keymap.vim

filetype plugin indent on
syntax on
set visualbell
set encoding=utf8
set clipboard=unnamed
set mouse=a

" vim format stuff {
  set autoindent
  set number
  set cb="exclude:.*"
  set expandtab
  set shiftwidth=2
  set softtabstop=2
  set hidden
  " for files
  set wildmenu
  " search options
  set ignorecase
  set smartcase
  set hlsearch
  set incsearch
  " Show “invisible” characters
  set colorcolumn=101,102,103
  set backspace=indent,eol,start
  set textwidth=99
  set linebreak
  " Vim keeps 50 commands in history(`q:` in normal mode.) Let's bump this to 1000.
  set history=1000
  set breakat=\(\[\{;\ ^I!@*-+:,./?
" }
