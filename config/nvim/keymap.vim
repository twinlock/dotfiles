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
" <leader>c => coc.nvim things (special plugin) 
" ^^^ exception is ctrlp which is mapped to... ctrl+p

" WINDOWS! {
  " make the current window size 100 (actually 106 to accomidate line numbers)
  " sizes s = small m = medium l = large
  nnoremap <leader>wl :vertical resize 107 <CR>
  nnoremap <leader>wm :vertical resize 60 <CR>
  nnoremap <leader>ws :vertical resize 20 <CR>

  nnoremap <leader>wvl :vertical resize 107 <CR>
  nnoremap <leader>wvm :vertical resize 60 <CR>
  nnoremap <leader>wvs :vertical resize 20 <CR>

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
  if has('nvim')
    tnoremap <Esc> <C-\><C-n>
  endif
" }

" BASIC VIM FUCNTIONS {
  " stop searching with gm
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

  nnoremap <leader>qf :copen<CR>
  nnoremap <leader>qfc :cclose<CR>
" }


" MACROS ARE AMAZING!
nnoremap Q @q
" Required for operations modifying multiple buffers like rename.
set hidden
" ======= PLUGIN Keybindings=========
" PLUGINS! {
  " CtrlP {
  " I will forget these, so im mapping it to a bunch of things i may think of
    nnoremap <leader>ppb :CtrlPBuffer<CR>
    nnoremap <leader>ppp :CtrlPMixed<CR>
    nnoremap <leader>ppo :CtrlPBuffer<CR>
    nnoremap <leader>ppt :CtrlPTags<CR>
    nnoremap <leader>ppm :CtrlPMRUFiles<CR>
    nnoremap <leader>pph :CtrlPMRUFiles<CR>
  " }
  " NERD Tree {
    nnoremap <leader>pntf :CHADopen<CR>
    nnoremap <leader>pnt :CHADopen<CR>
    "nnoremap <leader>pntf :NERDTreeFind<CR>
    "nnoremap <leader>pntt :NERDTreeToggle<CR>
    "nnoremap <leader>pnt :NERDTreeToggle<CR>
  " }
  " Vista {
    nnoremap <leader>pvs :Vista!!<CR>
  " }

  " incsearch {
    if has('nvim')
      map /  <Plug>(incsearch-forward)
      map ?  <Plug>(incsearch-backward)
      map g/ <Plug>(incsearch-stay)
      map n  <Plug>(incsearch-nohl-n)
      map N  <Plug>(incsearch-nohl-N)
    endif
  " }
  " telescope {
  " " Find files using Telescope command-line sugar.
    nnoremap <leader>pff <cmd>Telescope find_files<cr>
    nnoremap <leader>pfg <cmd>Telescope live_grep<cr>
    nnoremap <leader>pfb <cmd>Telescope buffers<cr>
    nnoremap <leader>pfh <cmd>Telescope help_tags<cr>
    
  " }

  " esearch {
  "  if has('nvim')
  "    " Start esearch prompt autofilled with one of g:esearch.use initial patterns
  "    call esearch#map('<leader>pff', 'esearch')
  "    " Start esearch autofilled with a word under the cursor
  "    call esearch#map('<leader>pfw', 'esearch-word-under-cursor')
  "  endif
  " }

  " vim-maximizer {
    noremap <leader>pmw :MaximizerToggle<CR>
  " }
  " rainbowparens {
    nnoremap <Leader>prp :RainbowToggle<CR>
  " }
  " gundo {
    nnoremap <Leader>pu :GundoToggle<CR>
    nnoremap <Leader>put :GundoToggle<CR>
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

  " coc.nvim {
    " as this is the primary IDE thing we have going, coc won't be using too many leader-p
    " mappings, many features will be leader-c (for complete)
    " Use tab for trigger completion with characters ahead and navigate.
    " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " other plugin before putting this into your config.
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> to trigger completion.
    if has('nvim')
      inoremap <silent><expr> <c-space> coc#refresh()
    else
      inoremap <silent><expr> <c-@> coc#refresh()
    endif

    " Make <CR> auto-select the first completion item and notify coc.nvim to
    " format on enter, <cr> could be remapped by other vim plugin
    inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    " Use K to show documentation in preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
      else
        execute '!' . &keywordprg . " " . expand('<cword>')
      endif
    endfunction

    " Use `[g` and `]g` to navigate diagnostics
    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " GoTo code navigation.
    nmap <leader>cgd <Plug>(coc-definition)
    nmap <leader>cgy <Plug>(coc-type-definition)
    nmap <leader>cgi <Plug>(coc-implementation)
    nmap <leader>cgr <Plug>(coc-references)
    " Symbol renaming.
    nmap <leader>crn <Plug>(coc-rename)
    " Formatting selected code.
    xmap <leader>cf  <Plug>(coc-format-selected)
    nmap <leader>cf  <Plug>(coc-format-selected)
    " Apply AutoFix to problem on the current line.
    nmap <leader>cqf  <Plug>(coc-fix-current)
    " Remap <C-f> and <C-b> for scroll float windows/popups.
    " Note coc#float#scroll works on neovim >= 0.4.0 or vim >= 8.2.0750
    nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

    " NeoVim-only mapping for visual mode scroll
    " Useful on signatureHelp after jump placeholder of snippet expansion
    if has('nvim')
      vnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<C-f>"
      vnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<C-b>"
    endif

    " Requires 'textDocument/selectionRange' support of language server.
    nmap <silent> <C-s> <Plug>(coc-range-select)
    xmap <silent> <C-s> <Plug>(coc-range-select)
    " Add `:Format` command to format current buffer.
    command! -nargs=0 Format :call CocAction('format')
    " Add `:Fold` command to fold current buffer.
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)
    " Add `:OR` command for organize imports of the current buffer.
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

    " Mappings for CoCList
    " Show all diagnostics.
    nnoremap <silent><nowait> <space>cma  :<C-u>CocList diagnostics<cr>
    " Manage extensions.
    nnoremap <silent><nowait> <space>cme  :<C-u>CocList extensions<cr>
    " Show commands.
    nnoremap <silent><nowait> <space>cmc  :<C-u>CocList commands<cr>
    " Find symbol of current document.
    nnoremap <silent><nowait> <space>cmo  :<C-u>CocList outline<cr>
    " Search workspace symbols.
    nnoremap <silent><nowait> <space>cms  :<C-u>CocList -I symbols<cr>
    " Do default action for next item.
    nnoremap <silent><nowait> <space>cmj  :<C-u>CocNext<CR>
    " Do default action for previous item.
    nnoremap <silent><nowait> <space>cmk  :<C-u>CocPrev<CR>
    " Resume latest coc list.
    nnoremap <silent><nowait> <space>cmp  :<C-u>CocListResume<CR>
  " }
" }
