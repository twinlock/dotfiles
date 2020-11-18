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
" Set pyenv root.
  if has('nvim')
    if empty($PYENV_ROOT)
      let s:pyenv_root = $HOME . '/.pyenv'
    else
      let s:pyenv_root = $PYENV_ROOT
    endif

    if isdirectory(s:pyenv_root)
      " Add pyenv shims to path.
      let s:pyenv_shims = s:pyenv_root . '/shims/'
      let $PATH = substitute($PATH, ':' . s:pyenv_shims, '', '')
      let $PATH .= ':' . s:pyenv_shims
    endif
  endif
" }
source ~/.config/nvim/plugins.vim
source ~/.config/nvim/keymap.vim

" more python config {
" use a virtualenv for python
  if has('nvim')
    " When reading a buffer (after 1s), and when writing (no delay).
    " call neomake#configure#automake('rw', 1000)

    if isdirectory(s:pyenv_root . '/versions/neovim2/')
      let g:python_host_prog = $PYENV_ROOT.'/versions/neovim2/bin/python'
    endif
    if isdirectory(s:pyenv_root . '/versions/neovim3/')
      let g:python3_host_prog = $PYENV_ROOT.'/versions/neovim3/bin/python'
    endif
    " Bonus example to set deoplete-jedi path from vim-pyenv.
    augroup pyenv-deoplete-jedi-path
      autocmd!
      autocmd User vim-pyenv-activate-post
            \ let g:deoplete#sources#jedi#python_path = g:pyenv#python_exec
      autocmd User vim-pyenv-deactivate-post
            \ unlet g:deoplete#sources#jedi#python_path
    augroup END
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
" Terraform config
" {
"  let g:deoplete#omni_patterns = {}
"
"  call deoplete#custom#option('omni_patterns', {
"  \ 'complete_method': 'omnifunc',
"  \ 'terraform': '[^ *\t"{=$]\w*',
"  \})
"
"  call deoplete#initialize()
"
"  " (Optional) Enable terraform plan to be include in filter
"  let g:syntastic_terraform_tffilter_plan = 1
"
"  " (Optional) Default: 0, enable(1)/disable(0) plugin's keymapping
"  let g:terraform_completion_keys = 1
"
"  " (Optional) Default: 1, enable(1)/disable(0) terraform module registry completion
"  let g:terraform_registry_module_completion = 0 
" }
