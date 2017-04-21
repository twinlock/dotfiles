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
call plug#begin('~/.config/nvim/plugged')
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

" ============== file movement ==============
" NerdTree {
  Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] } 
  Plug 'Xuyuanp/nerdtree-git-plugin' 
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
" deoplete {
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  " Use deoplete.
  let g:deoplete#enable_at_startup = 1
" }
" Eclim works, we just map it to ctrl space
" Eclim {
  let g:EclimCompletionMethod = 'omnifunc'
  "autocmd! BufWritePost,BufEnter * if  != "java" | Validate | endif
" }
" javacomplete2 {
  " Plug 'artur-shaik/vim-javacomplete2'
  "autocmd FileType java setlocal omnifunc=javacomplete#Complete
" }
" Neomake {
  Plug 'neomake/neomake'
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
  let g:esearch = {
        \ 'adapter':    'ag',
        \ 'backend':    'nvim',
        \ 'out':        'win',
        \ 'batch_size': 1000,
        \ 'use':        ['visual', 'hlsearch', 'last'],
        \}
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
" Delete surrounding parens
" surround {
  Plug 'tpope/vim-surround' 
" }
" Easily move windows around using <leader>ww 
" windowswap {
  Plug 'wesQ3/vim-windowswap'
" }
" maximize windows
" vim-maximizer {
  Plug 'szw/vim-maximizer'
" }
" Pants build syntax
" vim-pants {
  Plug 'pantsbuild/vim-pants'
" }
" Fixng copy paste shit
" focus-events {
  Plug 'tmux-plugins/vim-tmux-focus-events'
  Plug 'roxma/vim-tmux-clipboard'
" }
" session management {
  Plug 'tpope/vim-obsession'
" }

call plug#end()
