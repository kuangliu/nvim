-- Only required if you have packer in your `opt` pack
vim.cmd([[packadd packer.nvim]])

-- Automatically run :PackerCompile whenever plugins.lua is updated with an autocommand
vim.cmd([[ autocmd BufWritePost plugins.lua PackerCompile ]])

require('packer').startup(function()
  -- Packer can manage itself
  use {'wbthomason/packer.nvim', opt = true}

  -- One dark theme
  use {
    'navarasu/onedark.nvim',
    config = function() require'onedark'.setup {} end
  }

  use('rhysd/accelerated-jk')
  use('easymotion/vim-easymotion')

  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }

  use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
  use {'windwp/nvim-autopairs'}
  use {'schickling/vim-bufonly'}
  use {'voldikss/vim-floaterm'}
  use {'terrortylor/nvim-comment'}

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {'neovim/nvim-lspconfig'}

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
    },
  }

  use {'ray-x/lsp_signature.nvim'}
  use {'mhartington/formatter.nvim'}

  use {
    'kuangliu/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function() require('nvim-tree').setup {} end,
  }

  use {'mhinz/vim-startify'}
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

end)


