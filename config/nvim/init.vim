source ~/.config/nvim/plugins.vim
source ~/.config/nvim/keymap.vim

filetype plugin indent on
syntax on
set visualbell
set encoding=utf8
set clipboard=unnamed

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

" color scheme {
  colorscheme gruvbox
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  set termguicolors
  highlight LineNr ctermfg=darkred
  highlight ColorColumn ctermbg=darkgrey
  hi Visual term=reverse ctermbg=none guibg=Grey
  hi Search cterm=NONE ctermfg=darkgrey ctermbg=blue
  set background=dark

  highlight scalaDef cterm=bold
  highlight scalaClass cterm=bold
  highlight scalaObject cterm=bold
  highlight scalaTrait cterm=bold

  " Bold the cursor linenumber
  hi clear CursorLine
  hi clear CursorLineNR
  hi CursorLineNR cterm=bold
  augroup CLNRSet
      autocmd! ColorScheme * hi CursorLineNR cterm=bold
  augroup END
" }

