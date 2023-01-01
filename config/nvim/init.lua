local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local vim = _G.vim or vim -- suppress warning, allow complete without lua-dev
local api = vim.api

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.api.nvim_create_autocmd("BufWritePost", { command = "silent !terraform fmt %", pattern = { "*.hcl", "*.tf" } })
vim.api.nvim_create_autocmd("BufWritePost", { command = "source %", pattern = { "*/nvim/init.lua" } })
vim.api.nvim_create_autocmd("BufWritePost", { command = "PackerCompile", pattern = { "init.lua" } })
vim.api.nvim_create_autocmd("CmdWinEnter", { command = "startinsert" })

local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use({
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  })
  use 'tpope/vim-rhubarb'
  use { 'junegunn/fzf',
    run = function() vim.fn['fzf#install'](0) end
  }
  use 'junegunn/fzf.vim'
  -- use 'RRethy/nvim-base16'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-treesitter/playground' }
  use { 'mbbill/undotree' }
  use { 'github/copilot.vim' }
  use({ 'ggandor/leap.nvim', config = function()
    require('leap').set_default_keymaps()
  end
  })
  use { 'ishan9299/modus-theme-vim' }
  use { 'neoclide/coc.nvim', branch = 'release' }
  -- Install nvimtree
  use { 'nvim-tree/nvim-tree.lua' }
  use { 'nvim-tree/nvim-web-devicons' }
  use { 'ojroques/vim-oscyank' }
end)

require 'nvim-treesitter.configs'.setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  --    indent = {
  --        enable = true
  --    }
})
require("nvim-tree").setup({
  view = {
    float = {
      enable = true,
      open_win_config = {
        row = 0,
        col = 0,
        width = math.floor(vim.o.columns * 1),
        height = math.floor(vim.o.lines * 1),
      },
    },
  },
  -- Disable netrw completely
  disable_netrw = true,
})

if vim.g.vscode == nil then
  vim.cmd('colorscheme modus-vivendi')
end
vim.cmd('packadd cfilter')
vim.o.textwidth = 160
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.hlsearch = false
vim.o.autochdir = false
vim.o.relativenumber = false
vim.o.cursorline = false
vim.o.number = true
vim.o.foldlevel = 99
vim.o.mouse = 'a'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.autowriteall = true
vim.o.updatetime = 250
vim.o.signcolumn = 'yes'
vim.o.clipboard = 'unnamedplus'
vim.o.spell = false
vim.o.laststatus = 3
vim.o.linebreak = true
vim.o.nuw = 1
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.list = true
vim.o.listchars = 'tab:>-'
vim.o.grepprg = "rg --vimgrep --smart-case --follow"
vim.g.noshowmode = true
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.mapleader = ","
vim.g.fzf_preview_window = { 'up:40%:hidden', 'ctrl-g' }
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.termguicolors = true
vim.o.completeopt = 'menuone,noselect'
vim.o.scrolloff = 10
vim.o.cmdheight = 0
-- vim.api.nvim_set_option('cpoptions', 'y')
api.nvim_set_keymap('n', '<Leader>x', ':bp<CR>:bd#<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>f', ':Files<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>r', ':Rg ', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>a', ':Commands<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>b', ':Buffers<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>z', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeFindFileToggle<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('v', '<Leader>y', ':OSCYank<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Space>', 'q:', { noremap = true, silent = true })
api.nvim_set_keymap('v', '<Space>', 'q:', { noremap = true, silent = true })
api.nvim_set_keymap('n', "<M-\\>", "<Plug>Commentary", { silent = true })
api.nvim_set_keymap('v', "<M-\\>", "<Plug>Commentary", { silent = true })
api.nvim_set_keymap('n', '<C-p>', ':cp<CR>', { noremap = true, silent = true })
api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
api.nvim_set_keymap("i", "<C-\\>", 'copilot#Dismiss()', { silent = true, expr = true })
api.nvim_set_keymap('n', '<Leader>qc', ':cexpr []<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>qq', ':cclose<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<C-n>', ':cn<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>c', ':e ~/.config/nvim/init.lua<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<Leader>o', ":silent !open %:p:h<cr>", { noremap = true, silent = true })
