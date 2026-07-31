local opts = { noremap = true, silent = true }

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
-- <leader>p => plugin things (nerd tree, eclim, etc)

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
-- }
-- BASIC VIM FUNCTIONS {

-- MACROS ARE AMAZING!
keymap("n", "Q", "@q", opts)
-- Required for operations modifying multiple buffers like rename.
vim.o.hidden = true
-- ======= PLUGIN Keybindings=========
-- PLUGINS! {

-- }
