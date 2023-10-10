local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

require("lazy").setup({
  -- theme
  {
    'sainnhe/edge',
    lazy = false,
    priority = 1000,
    config=function()
      vim.cmd[[
        let g:edge_style = 'aura'
        let g:edge_enable_italic = 0
        let g:edge_disable_italic_comment = 1
        colorscheme edge
      ]]
    end
  },
  -- status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' }
  },
  -- syntax highlighting 
  {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function () 
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = { "bash", "c", "c_sharp", "cpp", "css", "lua", "vim", "vimdoc", "kotlin", "java",  "javascript", "html" },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },  
          })
      end
  },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  },
  -- ctrlp movement
  { "ctrlpvim/ctrlp.vim",
    config= function()
      vim.cmd[[
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
      ]]
    end
  },
  -- telescope, fast file fuzzy finder
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    dependencies = { {'nvim-lua/plenary.nvim'} }
  },
  -- Vista
  { 'liuchengxu/vista.vim' },
  -- file explorer
  {
    'kyazdani42/nvim-tree.lua',
    dependencies = {
      'kyazdani42/nvim-web-devicons',
    },
  },
  -- LSP stuff
  { 'neovim/nvim-lspconfig' },
  -- Autocompletion plugin
  { 'hrsh7th/nvim-cmp' },
  -- LSP source for nvim-cmp
  { 'hrsh7th/cmp-nvim-lsp' },
  -- Apparently it needs snippets
  { 'L3MON4D3/LuaSnip' },
  -- Snippets source for nvim-cmp
  { 'saadparwaiz1/cmp_luasnip' },
})

require('lualine').setup {
  options = { 
    theme  = 'material',
    component_separators = '|',
      section_separators = { left = '', right = '' },
    },
  sections = {
    lualine_a = {
      { 'mode', separator = { left = '' }, right_padding = 2 },
    },
    lualine_b = { 'filename', 'branch' },
    lualine_c = { 'fileformat' },
    lualine_x = {},
    lualine_y = { 'filetype', 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  extensions = {},
}

require("nvim-tree").setup {
  renderer = {
    group_empty = true,
  }
}

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "bash", "lua", "kotlin", "java", "python", "go", "ruby", "sql", "proto" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
  },
  indent = {
    enable = true,
  }
}

-- language server specifications  
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
require'lspconfig'.kotlin_language_server.setup{
  settings = { kotlin = { compiler = { jvm = { target = "17" } } } },
  on_attach = on_attach,
  capabilities = capabilities,
}

-- luasnip setup
local luasnip = require 'luasnip'


-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
