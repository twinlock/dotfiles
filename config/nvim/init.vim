" install vim plug {
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    if has('nvim')
      silent !curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
  endif
  if empty(glob('~/.vim/autoload/plug.vim'))
    if !has('nvim')
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
  endif
" }
" python config {
"" use a virtualenv for python
"  if has('nvim')
"    if isdirectory(s:pyenv_root . '/versions/neovim2/')
"      let g:python_host_prog = $PYENV_ROOT.'/versions/neovim2/bin/python'
"      let g:python_host_dir = $PYENV_ROOT.'/versions/neovim2/bin/'
"    endif
"    if isdirectory(s:pyenv_root . '/versions/neovim3/')
"      let g:python3_host_prog = $PYENV_ROOT.'/versions/neovim3/bin/python'
"      let g:python3_host_dir = $PYENV_ROOT.'/versions/neovim3/bin/'
"    endif
"  endif
" }
source ~/.config/nvim/plugins.vim
source ~/.config/nvim/keymap.vim

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
  colorscheme edge
  " colorscheme gruvbox-material

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

  " Bold the cursor linenumber
  hi clear CursorLine
  hi clear CursorLineNR
  hi CursorLineNR cterm=bold
  augroup CLNRSet
      autocmd! ColorScheme * hi CursorLineNR cterm=bold
  augroup END
" }
" Syntastic config
" {
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*

  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
" }
