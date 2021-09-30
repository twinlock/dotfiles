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
  let g:indentLine_concealcursor = 'nc'
" }
" Polyglot {
  Plug 'sheerun/vim-polyglot'
" }
" Kotlin {
"  Plug 'udalov/kotlin-vim'
" }
" Go {
"  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" }
" Java format {
"  Plug 'xuhdev/indent-java.vim'
" }
" Delete surrounding parens
" surround {
  Plug 'tpope/vim-surround'
" }
" Signal fx syntax
" signalflow {
  Plug 'signalfx/signalflow.vim'
" }

" ============== file movement ==============
" NerdTree {
  Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
  Plug 'Xuyuanp/nerdtree-git-plugin'
  let g:NERDTreeGitStatusUseNerdFonts = 1
  let g:NERDTreeDirArrows=0
  let g:NERDTreeShowBookmarks=1
  let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$', '^\.pants.d$']
  " prevent buffers from opening in nerdtree's buffer
  autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
  " prevent plug from doing the same
  let g:plug_window = 'noautocmd vertical topleft new'
" }
" devicons {
" moved to near nerdtree, needs to be installed after that to avoid compatibility issues
  Plug 'ryanoasis/vim-devicons'
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
" json {
  Plug 'kevinoid/vim-jsonc'
" }
" coc.nvim {
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " Python
  Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build' }
  Plug 'davidhalter/jedi-vim'
  " Json
  Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
  Plug 'weirongxu/coc-kotlin', {'do': 'yarn install --frozen-lockfile'}
  " GO
  autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
  " general coc.nvim configs, see the keymap for key setups{
    " Give more space for displaying messages.
    set cmdheight=2
    " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
    " delays and poor user experience.
    set updatetime=300
    " Don't pass messages to |ins-completion-menu|.
    set shortmess+=c
    " Always show the signcolumn, otherwise it would shift the text each time
    set signcolumn=yes
  " }
" }
" ============== tags/search related ==============
" Vista is basically tagbar in a LSP world
" Vista {
  Plug 'liuchengxu/vista.vim'
  let g:vista_default_executive = 'coc'
  let g:vista#renderer#enable_icon = 1
  let g:vista_fzf_preview = ['right:50%']
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

call plug#end()

" Required for operations modifying multiple buffers like rename.
set hidden
