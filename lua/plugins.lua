-- Only required if you have packer in your `opt` pack
vim.cmd([[packadd packer.nvim]])

-- Automatically run :PackerCompile whenever plugins.lua is updated with an autocommand
vim.cmd([[autocmd BufWritePost plugins.lua PackerCompile]])

require('packer').startup(function()
  -- Packer can manage itself
  use({ 'wbthomason/packer.nvim', opt = true })

  -- One dark theme
  use({ 'kuangliu/onedark.vim' })

  use({ 'rhysd/accelerated-jk' })
  use({ 'easymotion/vim-easymotion' })

  use({
    'hoob3rt/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  })

  use({ 'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons' })
  use({
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({})
    end,
  })
  use({ 'schickling/vim-bufonly' })
  use({ 'terrortylor/nvim-comment' })

  use({
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
    },
  })

  use({ 'neovim/nvim-lspconfig' })

  use({
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'kuangliu/friendly-snippets',
    },
  })

  use({
    'ray-x/lsp_signature.nvim',
    config = function()
      require('lsp_signature').setup({})
    end,
  })
  use({ 'mhartington/formatter.nvim' })

  use({
    'kuangliu/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
  })

  use({ 'mhinz/vim-startify' })
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  })

  use({ 'akinsho/toggleterm.nvim' })
  use({ 'karb94/neoscroll.nvim' })

  use({
    'rcarriga/nvim-dap-ui',
    requires = { 'mfussenegger/nvim-dap' },
  })

  use({
    'ur4ltz/surround.nvim',
    config = function()
      require('surround').setup({ mappings_style = 'surround' })
    end,
  })

  use({ 'Shatur/neovim-session-manager' })
  use({ 'stevearc/aerial.nvim' })
end)
