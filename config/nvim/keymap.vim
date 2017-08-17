" Remap colon to semicolon and vis-versa
nnoremap : ;
nnoremap ; :
vnoremap ; :
vnoremap : ;
map <F1> <Esc>
imap <F1> <Esc>

" map leader to space
let mapleader = " "

" General format:
" <leader>w => window things (movement is just hjkl thou)
" <leader>g => vim things (numbers, turn off search highlight)
" <leader>p => plugin things (nerd tree, eclim, etc)
" ^^^ exception is ctrlp which is mapped to... ctrl+p

" WINDOWS! {
  " make the current window size 100 (actually 106 to accomidate line numbers)
  " sizes s = small m = medium l = large
  nnoremap <leader>wl :vertical resize 107 <CR>
  nnoremap <leader>wm :vertical resize 60 <CR>
  nnoremap <leader>ws :vertical resize 20 <CR>

  nnoremap <leader>whl :resize 100 <CR>
  nnoremap <leader>whm :resize 45 <CR>
  nnoremap <leader>whs :resize 20 <CR>
  " move windows with leader arrow
  nnoremap <silent> <Leader>h :wincmd h<CR>
  nnoremap <silent> <Leader>j :wincmd j<CR>
  nnoremap <silent> <Leader>k :wincmd k<CR>
  nnoremap <silent> <Leader>l :wincmd l<CR>
" }
" terminal {
  tnoremap <Esc> <C-\><C-n>
" }

" BASIC VIM FUCNTIONS {
  " stop searching wiht gm
  nnoremap <silent> <leader>gm :silent noh<CR>
  " Enter/leave numbers .
  nnoremap <leader>gn :set invnumber<CR>
  " Enter/leave numbers .
  nnoremap <leader>grn :set invrelativenumber<CR>
  " Enter/leave paste mode.
  nnoremap <leader>gp :set invpaste<CR>:set paste?<CR>
  " Edit alternate file.
  nnoremap <leader>gg :e#<CR>
  " Turn on word-wrapping.
  nnoremap <leader>gw :se tw=99<CR>
  " clean out trialing whitespace
  nnoremap <leader>gc :%s/\s\+$//g<CR>
" }


" MACROS ARE AMAZING!
nnoremap Q @q

" ======= PLUGIN Keybindings=========
" PLUGINS! {
  " CtrlP {
  " I will forget these, so im mapping it to a bunch of things i may think of
    nnoremap <leader>ppb :CtrlPBuffer<CR>
    nnoremap <leader>ppp :CtrlPBuffer<CR>
    nnoremap <leader>ppo :CtrlPBuffer<CR>
    nnoremap <leader>ppt :CtrlPTags<CR>
    nnoremap <leader>ppm :CtrlPMRUFiles<CR>
    nnoremap <leader>pph :CtrlPMRUFiles<CR>
  " }

  " NERD Tree {
    nnoremap <leader>pntf :NERDTreeFind<CR>
    nnoremap <leader>pntt :NERDTreeToggle<CR>
    nnoremap <leader>pnt :NERDTreeToggle<CR>
  " }

  " incsearch {
    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)
    map n  <Plug>(incsearch-nohl-n)
    map N  <Plug>(incsearch-nohl-N)
  " }
  " esearch {
    " Start esearch prompt autofilled with one of g:esearch.use initial patterns
    call esearch#map('<leader>pff', 'esearch')
    " Start esearch autofilled with a word under the cursor
    call esearch#map('<leader>pfw', 'esearch-word-under-cursor')
  " }
  " vim-maximizer {
    noremap <leader>pmw :MaximizerToggle<CR>
  " }

  " neosnippet {
    let g:UltiSnipsExpandTrigger='<c-s>'
    let g:UltiSnipsJumpForwardTrigger='<c-j>'
    let g:UltiSnipsJumpBackwardTrigger='<c-k>'
    let g:UltiSnipsListSnippets='<c-l>' 
  " }
  " gen_tags {
    nnoremap <leader>ptc :GenCtags<CR>
    nnoremap <leader>ptg :GenGTAGS<CR>
  " }
  " tagbar {}
    nnoremap <leader>ptb :TagbarToggle<CR>
    nnoremap <leader>ptbt :TagbarToggle<CR>
    nnoremap <leader>ptt :TagbarToggle<CR>
  "

  " rainbowparens {
    nnoremap <Leader>prp :RainbowToggle<CR>
  " }

  " gundo {
    nnoremap <Leader>pu :GundoToggle<CR>
    nnoremap <Leader>put :GundoToggle<CR>
  " }

  " deoplete {
    " deoplete tab-complete
    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
  " }

  " eclim {
    inoremap <C-Space> <C-x><C-o>
    inoremap <C-@> <C-Space>
    nnoremap <leader>jc :JavaCorrect<CR>
    nnoremap <leader>jdc :JavaDocComment<CR>
    nnoremap <leader>jch :JavaCallHierarchy<CR>
    nnoremap <leader>juf :JUnitFindTest<CR>
    nnoremap <leader>juft :JUnitFindTest<CR>
    nnoremap <leader>jut :JUnitFindTest<CR>
    nnoremap <leader>jh :JavaHierarchy<CR>
    nnoremap <leader>ji :JavaImport<CR>
    nnoremap <leader>jf :JavaFormat<CR>
    nnoremap <leader>jv :Validate<CR>
    nnoremap <leader>si :ScalaImport<CR>
    nnoremap <leader>sji :JavaImportOrganize<CR>
    nnoremap <leader>ssi :SortScalaImports<CR>
  " }
  " git_gutter {
    nnoremap <leader>pggt :GitGutterToggle<CR>
    nnoremap <leader>pggn :GitGutterNextHunk<CR>
    nnoremap <leader>pggp :GitGutterPrevHunk<CR>
    nnoremap <leader>pggs :GitGutterStageHunk<CR>
    nnoremap <leader>pggu :GitGutterUndoHunk<CR>
    nnoremap <leader>pggv :GitGutterPreviewHunk<CR>

    nnoremap <leader>pgt :GitGutterToggle<CR>
    nnoremap <leader>pgn :GitGutterNextHunk<CR>
    nnoremap <leader>pgp :GitGutterPrevHunk<CR>
    nnoremap <leader>pgs :GitGutterStageHunk<CR>
    nnoremap <leader>pgu :GitGutterUndoHunk<CR>
    nnoremap <leader>pgv :GitGutterPreviewHunk<CR>
  " }
" }
