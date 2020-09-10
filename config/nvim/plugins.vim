" check whether vim-plug is installed and install it if necessary
let plugpath = expand('<sfile>:p:h'). '/autoload/plug.vim'
if !filereadable(plugpath)
  if executable('curl')
    let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
    if v:shell_error
      echom "Error downloading vim-plug. Please install it manually.\n"
      exit
    endif
  else
    echom "vim-plug not installed. Please install it manually or install curl.\n"
    exit
  endif
endif

" Initialize plugin system
if has('nvim')
  call plug#begin('~/.config/nvim/plugged')
else
  call plug#begin('~/.config/vim/plugged')
endif

" ============== COLOR ==============
" colorschemes and handy dandy statusline things
" Plug 'joshdick/onedark.vim'

" this requires patched fonts, remember~ to get one from:
"   https://github.com/ryanoasis/nerd-fonts
" Airline {
  Plug 'vim-airline/vim-airline'
  let g:airline#extensions#tabline#enabled = 1
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#tabline#show_buffers = 0
" }

" Gruvbox {
  Plug 'morhetz/gruvbox'
  let g:gruvbox_contrast_dark="soft"
  if !has("gui_running")
      let g:gruvbox_italicize_comments=0
  endif
" }

" Color nested matching parentheses with different colors
" Rainbowparens {
  Plug 'luochen1990/rainbow'
  let g:rainbow_active = 1
" }
" devicons {
  Plug 'ryanoasis/vim-devicons'
" }
" vim-slim {
  Plug 'slim-template/vim-slim'
" }

" ============== file formatting ==============
" Show the indent level
" Indentline {
  Plug 'Yggdroot/indentLine'
  let g:indentLine_color_term = 239
  let g:indentLine_color_gui = '#606775'
  let g:indentLine_char = '.'
" }
" Kotlin {
  Plug 'udalov/kotlin-vim'
" }
" Java format {
  Plug 'xuhdev/indent-java.vim'
" }
" Delete surrounding parens
" surround {
  Plug 'tpope/vim-surround'
" }
" Pants build syntax
" vim-pants {
  Plug 'pantsbuild/vim-pants'
" }
" Signal fx syntax
" signalflow {
  Plug 'signalfx/signalflow.vim'
" }

" ============== file movement ==============
" NerdTree {
  Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
  " While the git plugin is nice, ive had all sorts of performance problems with it, not sure what
  " to do other than to just remove it, sadly.
  " Plug 'Xuyuanp/nerdtree-git-plugin'
  let g:NERDTreeDirArrows=0
  let g:NERDTreeShowBookmarks=1
  let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$', '^\.pants.d$']
" }

" ctrlp {
  Plug 'ctrlpvim/ctrlp.vim'
  let g:ctrlp_match_window = 'order:ttb,max:20'
  " dont serch but every 250ms, eliminates some annoying fumble finger behavior
  let g:ctrlp_lazy_update = 150
  let g:ctrlp_working_path_mode = 'ra'
  let g:ctrlp_working_path_mode = 0
  " Regex mode by default (<c-r> to toggle)
  let g:ctrlp_regexp = 0
  let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$|\.pants.d$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$|\.swp$' }
  if executable('ag')
    let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
  else
    let s:ctrlp_fallback = 'find %s -type f'
  endif
  let g:ctrlp_user_command = {
                \ 'types': {
                \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': s:ctrlp_fallback
                \ }
" }
" Easily navigate vim's undo tree visually
" Gundo {
  Plug 'sjl/gundo.vim'
" }

" ============== autocompletion/ code building ==============
" ijaas {
" intellij as a service, testing if it works (thus the non standard location)
  if !has('nvim')
  "  Plug '~/workspace/ijaas/vim/'
  endif
" }
" deoplete {
  if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'beeender/Comrade'
  else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
  " Use deoplete.
  let g:deoplete#enable_at_startup = 1
" }
" Java:
" Neomake {
  if !exists('g:vscode') && has('nvim')
    Plug 'neomake/neomake'
    " stupid way to disable java check
    let g:loaded_neomake_java_javac_maker = 1
    autocmd! BufWritePost *.rb :Neomake
    autocmd! BufWritePost *.py :Neomake
  endif
" }
" Python:
" Jedi {
  Plug 'davidhalter/jedi'
" }
" Pyclient {
  Plug 'neovim/python-client'
" }
" Deoplete Jedi {
  Plug 'zchee/deoplete-jedi'
" }
" vim pyenv {
  Plug 'lambdalisue/vim-pyenv'
" }
" vim pydocstring {
  Plug 'heavenshell/vim-pydocstring'
" }
" Ruby:
" vim-ruby {
  Plug 'vim-ruby/vim-ruby'
" }
" Rails support (:A, :R, :Rmigration, :Rextract)
" vim-rails {
  Plug 'tpope/vim-rails', { 'for': ['ruby', 'eruby', 'haml', 'slim'] }
" }
" Bundler support (plays nicely with tpope/gem-ctags)
" vim-bundler {
  Plug 'tpope/vim-bundler', { 'for': ['ruby', 'eruby', 'haml', 'slim'] }
" }
" Terraform support
" {
  Plug 'hashivim/vim-terraform'
  Plug 'vim-syntastic/syntastic'
  Plug 'juliosueiras/vim-terraform-completion'
" }

" ============== tags/search related ==============
" all this does is create tags async
" gen_tags {
  Plug 'jsfaint/gen_tags.vim'
  let g:gen_tags#ctags_opts='--exclude=*.js -R'
" }
" tagbar {
  Plug 'majutsushi/tagbar'
" }

" incremental search for vim
" incsearch {
  Plug 'haya14busa/incsearch.vim'
" }
" A much faster replacement for 99% of the uses of grep
" ag {
  Plug 'rking/ag.vim'
  if executable('ag')
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor
  endif
" }
" similar to sublime's find replace:
" esearch {
  Plug 'eugen0329/vim-esearch'
  if has('nvim')
    let g:esearch = {
          \ 'adapter':    'ag',
          \ 'backend':    'nvim',
          \ 'out':        'win',
          \ 'batch_size': 1000,
          \ 'use':        ['visual', 'hlsearch', 'last'],
          \}
  else
    let g:esearch = {
          \ 'adapter':    'ag',
          \ 'backend':    'vim8',
          \ 'out':        'win',
          \ 'batch_size': 1000,
          \ 'use':        ['visual', 'hlsearch', 'last'],
          \}
  endif
" }
" Use * on visually selected text to search for it
" visual star search {
  Plug 'bronson/vim-visual-star-search'
" }
" ============== GIT ==============
" Git gutter shows which lines have been edited
" git gutter {
  Plug 'airblade/vim-gitgutter'
  " i hate it when plugins take over keys
  let g:gitgutter_map_keys = 0
" }
" classic git plugin
" git fugitive {
  Plug 'tpope/vim-fugitive'
" }

" ============== random ==============
" Easily move windows around using <leader>ww
" windowswap {
  Plug 'wesQ3/vim-windowswap'
" }
" maximize windows
" vim-maximizer {
  Plug 'szw/vim-maximizer'
" }
" Fixng copy paste shit
" focus-events {
  Plug 'tmux-plugins/vim-tmux-focus-events'
  Plug 'roxma/vim-tmux-clipboard'
" }
" session management {
  Plug 'tpope/vim-obsession'
" }
" uniting all the stupidity {
  if has('nvim')
    Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
  endif
" }

call plug#end()

" Required for operations modifying multiple buffers like rename.
set hidden
