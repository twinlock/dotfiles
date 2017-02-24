set nocompatible
filetype off                  " required

" ===== Vundle Plugins  ==============================================
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'JavaDecompiler.vim'

" scala syntax and defaults for the scala language
Plugin 'derekwyatt/vim-scala'

"Python
Plugin 'hynek/vim-python-pep8-indent'
"Plugin 'nvie/vim-flake8'
Plugin 'heavenshell/vim-pydocstring'

Plugin 'Valloric/YouCompleteMe'
" auto syntax highlighting~
Plugin 'scrooloose/syntastic'
" Nerd Tree tree viewer
Plugin 'scrooloose/nerdtree'
" Tagbar does some cool things with code summary
Plugin 'majutsushi/tagbar'
" incremental search for vim
Plugin 'haya14busa/incsearch.vim'
" A much faster replacement for 99% of the uses of grep
Plugin 'rking/ag.vim'
" Use * on visually selected text to search for it
Plugin 'bronson/vim-visual-star-search'

" Delete surrounding parens
Plugin 'tpope/vim-surround' 
" Color nested matching parentheses with different colors
Plugin 'kien/rainbow_parentheses.vim'
" Gruvbox color scheme
Plugin 'morhetz/gruvbox'
" handy dandy statusline things
Plugin 'vim-airline/vim-airline'

" Async vim compiling with tmux
Plugin 'tpope/vim-dispatch'

" Easily navigate vim's undo tree visually
Plugin 'sjl/gundo.vim'
call vundle#end()            " required
filetype plugin indent on    " required
syntax on
set visualbell

" ===== key remaps  ==============================================
let mapleader = " "
" make the current window size 80 (actually 86 to accomidate line numbers)
nnoremap <leader>ws :vertical resize 107 <CR>
nnoremap Q @q
" Some nice shortcuts:
" Enter/leave numbers .
nnoremap gn :set invnumber<CR>
" Enter/leave numbers .
nnoremap grn :set invrelativenumber<CR>
" Enter/leave paste mode.
nnoremap gp :set invpaste<CR>:set paste?<CR>
" Edit alternate file.
nnoremap gg :e#<CR>
" Turn on word-wrapping.
nnoremap gw :se tw=99<CR>
" Execute contents of register a.
nnoremap \ @a
" Get rid of trailing whitespace.
nnoremap gc :%s/[ <Tab>]\+$//<CR>
" stop searching wiht ctrl-m
nnoremap <silent> <C-m> :silent noh<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
cmap W w

map <F1> <Esc>
imap <F1> <Esc>
" move windows with alt arrow
nnoremap <silent> <Leader>h :wincmd h<CR>
nnoremap <silent> <Leader>j :wincmd j<CR>
nnoremap <silent> <Leader>k :wincmd k<CR>
nnoremap <silent> <Leader>l :wincmd l<CR>
" set F8 and leader gt for tagbar (code summary)
nmap <F8> :TagbarToggle<CR>
nmap <leader>gt :TagbarToggle<CR>
" incremental search (better search)
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)

" pydoc
nmap <silent> <C-_> <Plug>(pydocstring)

nnoremap <Leader>g :GundoToggle<CR>
nnoremap <leader>c :!ctags -R $(git rev-parse --show-toplevel) && echo "Done generating ctags"<CR>
nnoremap <leader>t :CtrlPTag<cr>
function! ToggleNERDTreeAndTagbar()
  let w:jumpbacktohere = 1
  " Detect which plugins are open
  if exists('t:NERDTreeBufName')
    let nerdtree_open = bufwinnr(t:NERDTreeBufName) != -1
  else
    let nerdtree_open = 0
  endif
  let tagbar_open = bufwinnr('__Tagbar__') != -1

  " Perform the appropriate action
  if nerdtree_open && tagbar_open
    NERDTreeClose
    TagbarClose
  elseif nerdtree_open
    TagbarOpen
    wincmd K
    wincmd j
    wincmd L
    wincmd h
    vertical resize 30
  elseif tagbar_open
    NERDTree
    wincmd K
    wincmd j
    wincmd L
    wincmd h
    vertical resize 30
  else
    NERDTree
    TagbarOpen
    wincmd K
    wincmd j
    wincmd L
    wincmd h
    vertical resize 30
  endif

  " Jump back to the original window
  for window in range(1, winnr('$'))
    execute window . 'wincmd w'
    if exists('w:jumpbacktohere')
      unlet w:jumpbacktohere
      break
    endif
  endfor
endfunction
nnoremap <leader>gs :call ToggleNERDTreeAndTagbar()<CR>

let g:customtabsize=1
function! ToggleTabSize()
  if g:customtabsize
    :set shiftwidth=2
    :set tabstop=2
    :set softtabstop=2
    :let g:customtabsize=0
  else
    :set shiftwidth=4
    :set tabstop=4
    :set softtabstop=4
    :let g:customtabsize=1
  endif
endfunction
nnoremap <F3> mz:execute ToggleTabSize()<CR>'z

" Custom function to populate the argslist with files in the quickfix list
" Usage can be found here:
" http://vimcasts.org/episodes/project-wide-find-and-replace/
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()

function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

nnoremap <Leader>g :GundoToggle<CR>

" eclim things
nnoremap <leader>jc :JavaCorrect<CR>
nnoremap <leader>jch :JavaCallHierarchy<CR>
nnoremap <leader>ji :JavaImport<CR>
nnoremap <leader>si :ScalaImport<CR>
nnoremap <leader>ssi :SortScalaImports<CR>

" Remap colon to semicolon and vis-versa
nnoremap : ;
nnoremap ; :
vnoremap ; :
vnoremap : ;
" ===== Formatty things  ==============================================
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

" ===== Configy things  ==============================================
" CommandT setup
let g:ctrlp_cmd = 'CtrlP'

" Search by file name by default (<c-d> switches modes)
let g:ctrlp_by_filename = 0

" Regex mode by default (<c-r> to toggle)
let g:ctrlp_regexp = 0

let g:ctrlp_working_path_mode = 'acr'

" CtrlP window appears at bottom instead of top
let g:ctrlp_match_window_bottom = 1

set wildignore+=*.o,*.obj,.git,*.class,*.so,*.swp,*.zip,*.class,*.tar.gz,*.tgz,*.tar,*.gzip,*.jar,*.pyc
"*/lib/python3.5/*,*/build/*,refined*/*,./*virtualenv/*,*/__pycache__/*,

" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list
" make tab completion for files/buffers act like bash
set wildmenu

" Always show status line
set laststatus=2
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
"" Show the cursor position
"set ruler
"" Show the filename in the window titlebar
"set title
" Show the (partial) command as it’s being typed
set showcmd

" only search the following directories,
" let g:ctrlp_directories = “map([)
hi Search cterm=NONE ctermfg=white ctermbg=darkblue

" Override scala.vim's tabstop of 2 spaces
" au BufNewFile,BufRead *.scala set shiftwidth=4 tabstop=4
" au BufNewFile,BufRead *.cpp set shiftwidth=4 tabstop=4

" syntactic setup
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height=5
let g:syntastic_python_python_exec = "python3"
let g:syntastic_python_pylint_exec = "pylint"
" Eclim
let g:EclimCompletionMethod = 'omnifunc'
let g:EclimPythonValidate = 0
let g:python_pep8_indent_multiline_string = 1
" YCM
" YCM's identifier completer will also collect identifiers from tags files
"let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_python_binary_path = "python3"
" incsearch
" :h g:incsearch#auto_nohlsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1
"Tagbar
let g:tagbar_show_visibility = 0
let g:tagbar_width = 36
let g:tagbar_ctags_bin='/usr/local/bin/ctags'
let g:tagbar_type_scala = {
    \ 'ctagstype' : 'Scala',
    \ 'kinds'     : [
        \ 'p:packages:1',
        \ 'V:values',
        \ 'v:variables',
        \ 'T:types',
        \ 't:traits',
        \ 'o:objects',
        \ 'a:aclasses',
        \ 'c:classes',
        \ 'r:cclasses',
        \ 'm:methods'
    \ ]
\ }
" Show line numbers with NT
let g:NERDTreeShowLineNumbers=1
let g:NERDTreeDirArrows=0
let g:NERDTreeShowBookmarks=1
" Allow backspacing beyond start of insert mode
set backspace=indent,eol,start

set matchtime=2
set scrolloff=2

nnoremap <Leader>0 :RainbowParenthesesToggle<CR>
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" If editing a scala file, set the makeprg to compile with gradle
au BufNewFile,BufRead *.scala set makeprg=gradle\ test\ --console=plain
let g:scala_sort_across_groups=1
let g:scala_first_party_namespaces='\(com.metabiota\|controllers\|views\|models\)'
" associate *.avsc with json filetype
au BufRead,BufNewFile *.avsc setfiletype json
au BufRead,BufNewFile *.avsc set shiftwidth=4 tabstop=4
" Ensure jsons are 4
au BufNewFile,BufRead *.json set shiftwidth=4 tabstop=4
" Ensure pythons are 4
au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab

nnoremap <Leader>m :Make<CR>

" # # # # # Airline config # # # # #
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#show_buffers = 0
"set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h15
"let g:Powerline_symbols='unicode'
"let g:Powerline_symbols = 'fancy'
"set encoding=utf-8
"set t_Co=256
"set term=xterm-256color
"set termencoding=utf-8

" Ag - The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
let g:ctrlp_working_path_mode = 'ra'
" ===== Colory things  ==============================================

colorscheme gruvbox
let g:gruvbox_contrast_dark="soft"
highlight LineNr ctermfg=darkred
highlight ColorColumn ctermbg=darkgrey
hi Visual term=reverse ctermbg=none guibg=Grey
hi Search cterm=NONE ctermfg=darkgrey ctermbg=blue
" Gruvbox colorscheme options

" Gruvbox's italics go wonky outside of the GUI vim
if !has("gui_running")
    let g:gruvbox_italicize_comments=0
endif
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
