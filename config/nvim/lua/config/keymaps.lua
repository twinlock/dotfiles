local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Remap colon to semicolon and vis-versa
keymap({ "n", "v" }, ";", ":", opts)
keymap({ "n", "v" }, ":", ";", opts)
-- F1 is escape
keymap({ "x", "v", "n", "i" }, "<F1>", "<Esc>", opts)

vim.g.mapleader = " "

-- lazy has this thing where when exiting visual, you have a split second
-- where it will move the line up or down. IT DRIVES ME NUTS.
-- this disables that (you can still get the same functionality with alt).
keymap("v", "<M-k>", "<Esc>", { noremap = true })
keymap("v", "<M-j>", "<Esc>", { noremap = true })
-- General format:
-- <leader>w => window things (movement is just hjkl thou)
-- <leader>g => vim things (numbers, turn off search highlight)
-- <leader>p => plugin things (nerd tree, eclim, etc)
-- <leader>c => coc.nvim things (special plugin)

-- WINDOWS! {
-- make the current window size 100 (actually 106 to accomidate line numbers)
-- sizes s = small m = medium l = large
keymap("n", "<leader>wl", ":vertical resize 107 <CR>", opts)
keymap("n", "<leader>wm", ":vertical resize 60 <CR>", opts)
keymap("n", "<leader>ws", ":vertical resize 20 <CR>", opts)

keymap("n", "<leader>wvl", ":vertical resize 107 <CR>", opts)
keymap("n", "<leader>wvm", ":vertical resize 60 <CR>", opts)
keymap("n", "<leader>wvs", ":vertical resize 20 <CR>", opts)

keymap("n", "<leader>whl", ":resize 100 <CR>", opts)
keymap("n", "<leader>whm", ":resize 45 <CR>", opts)
keymap("n", "<leader>whs", ":resize 20 <CR>", opts)
-- move windows with leader arrow
keymap("n", "<Leader>h", ":wincmd h<CR>", opts)
keymap("n", "<Leader>j", ":wincmd j<CR>", opts)
keymap("n", "<Leader>k", ":wincmd k<CR>", opts)
keymap("n", "<Leader>l", ":wincmd l<CR>", opts)
-- move tabs with leader tab
keymap("n", "<leader><Tab>", "<Cmd>BufferLineCycleNext<CR>")
keymap("n", "<leader><S-Tab>", "<Cmd>BufferLineCyclePrev<CR>")
-- }
-- terminal {
--keymap("t", "<Esc>", "<C-\\><C-n>", opts)
-- }
-- BASIC VIM FUNCTIONS {
-- stop searching with gm
keymap("n", "<leader>gm", ":silent noh<CR>", opts)
-- Enter/leave numbers .
keymap("n", "<leader>gn", ":set invnumber<CR>", opts)
-- Enter/leave numbers .
keymap("n", "<leader>grn", ":set invrelativenumber<CR>", opts)
-- Enter/leave paste mode.
keymap("n", "<leader>gp", ":set invpaste<CR>:set paste?<CR>", opts)
-- Edit alternate file.
keymap("n", "<leader>gg", ":e#<CR>", opts)
-- Turn on word-wrapping.
keymap("n", "<leader>gw", ":se tw=99<CR>", opts)
-- clean out trialing whitespace
keymap("n", "<leader>gc", ":%s/\\s\\+$//g<CR>", opts)

keymap("n", "<leader>qf", ":copen<CR>", opts)
keymap("n", "<leader>qfc", ":cclose<CR>", opts)
-- }

-- MACROS ARE AMAZING!
keymap("n", "Q", "@q", opts)
-- Required for operations modifying multiple buffers like rename.
vim.o.hidden = true
-- ======= PLUGIN Keybindings=========
-- PLUGINS! {
-- Neovim Tree {
keymap("n", "<leader>pnt", ":Neotree source=last reveal=false<CR>", opts)
keymap("n", "<leader>pntf", ":Neotree source=filesystem reveal=true<CR>", opts)
keymap("n", "<leader>pntb", ":Neotree source=buffers <CR>", opts)
-- Document symbols
keymap("n", "<leader>po", ":Neotree position=right source=document_symbols<CR>", opts)
-- }
-- telescope {
-- " Find files using Telescope command-line sugar.
keymap("n", "<leader>pff", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>pfg", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>pfb", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<leader>pfh", "<cmd>Telescope help_tags<cr>", opts)
-- }
-- rainbowparens {
keymap("n", "<Leader>prp", ":RainbowToggle<CR>", opts)
-- }
-- gundo {
keymap("n", "<Leader>pu", ":GundoToggle<CR>", opts)
keymap("n", "<Leader>put", ":GundoToggle<CR>", opts)
-- }
-- }

-- git_gutter {
keymap("n", "<leader>pggt", ":GitGutterToggle<CR>", opts)
keymap("n", "<leader>pggn", ":GitGutterNextHunk<CR>", opts)
keymap("n", "<leader>pggp", ":GitGutterPrevHunk<CR>", opts)
keymap("n", "<leader>pggs", ":GitGutterStageHunk<CR>", opts)
keymap("n", "<leader>pggu", ":GitGutterUndoHunk<CR>", opts)
keymap("n", "<leader>pggv", ":GitGutterPreviewHunk<CR>", opts)
keymap("n", "<leader>pgt", ":GitGutterToggle<CR>", opts)
keymap("n", "<leader>pgn", ":GitGutterNextHunk<CR>", opts)
keymap("n", "<leader>pgp", ":GitGutterPrevHunk<CR>", opts)
keymap("n", "<leader>pgs", ":GitGutterStageHunk<CR>", opts)
keymap("n", "<leader>pgu", ":GitGutterUndoHunk<CR>", opts)
keymap("n", "<leader>pgv", ":GitGutterPreviewHunk<CR>", opts)
-- }
-- }
