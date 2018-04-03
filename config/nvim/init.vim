source ~/.config/nvim/plugins.vim
source ~/.config/nvim/keymap.vim

" use a virtualenv for python
" python config {
" Set pyenv root.
  if empty($PYENV_ROOT)
    let s:pyenv_root = $HOME . '/.pyenv'
  else
    let s:pyenv_root = $PYENV_ROOT
  endif

  if has('nvim')
    if isdirectory(s:pyenv_root . '/versions/neovim2/')
      let g:python_host_prog = $PYENV_ROOT.'/versions/neovim2/bin/python'
    endif
    if isdirectory(s:pyenv_root . '/versions/neovim3/')
      let g:python3_host_prog = $PYENV_ROOT.'/versions/neovim3/bin/python'
    endif
  endif
" }

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

" color scheme {
  colorscheme gruvbox
  if has('nvim')
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  else
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
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

