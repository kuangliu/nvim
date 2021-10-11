require('plugins')
require('settings')
require('key')

----------------------------------
-- Lualine & bufferline
----------------------------------
local function my_fpath_func()
  return vim.fn.expand('%:p')
end

require('lualine').setup {
  options = { 
    theme = 'onedark', section_separators = { left = '', right = ''},
    component_separators = { left = '', right = ''},
    icons_enabled = false,
  },
  sections = {
    lualine_c = {my_fpath_func}
  },
}

require('bufferline').setup {
  options = {
    indicator_icon = '',
    modified_icon = '•',
    show_buffer_icons = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    enforce_regular_tabs = false,
    max_name_length = 300,
    tab_size = 15,
  },
  highlights = {
    fill = {
      guibg = '#282C34',
    },
    background = {
      gui = 'bold',
      guifg = '#778899',
      guibg = '#282C34',
    },
    tab_close = {
      guibg = '#282C34',
    },
    separator = {
      guifg = '#282C34',
      guibg = '#282C34',
    },
    buffer_selected = {
      gui = 'bold',
      guifg = '#282C34',
      guibg = '#778899',
    },
    modified_selected = {
      gui = 'bold',
      guifg = '#282C34',
      guibg = '#778899',
    },
  },
}

----------------------------------
-- Nvim-cmp
----------------------------------
local cmp = require('cmp')
cmp.setup{
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },
  mapping = {
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })
  },
}

----------------------------------
-- LSP
----------------------------------
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', '<Leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- buf_set_keymap('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- buf_set_keymap('n', '<Leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)  -- pyright can't do formatting
  -- vim.api.nvim_command[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
end

nvim_lsp['pyright'].setup{
  on_attach = on_attach,
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
}

nvim_lsp['ccls'].setup{
  on_attach = on_attach,
}

----------------------------------
-- Formatter
----------------------------------
require('formatter').setup({
  filetype = {
    python = {
      function()
        return {
          exe = 'autopep8',
          args = { '-' },
          stdin = true,
        }
      end
    },
    cpp = {
        -- clang-format
       function()
          return {
            exe = 'clang-format',
            args = {'--assume-filename', vim.api.nvim_buf_get_name(0), '--style', 'Chromium'},
            stdin = true,
            cwd = vim.fn.expand('%:p:h')  -- Run clang-format in cwd of the file.
          }
        end
    },
  }
})

-- Format on save
vim.api.nvim_exec([[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost *.py,*.h,*cc silent! FormatWrite
  augroup END
  ]], true)

----------------------------------
-- Nvim-tree
----------------------------------
local tree_cb = require('nvim-tree.config').nvim_tree_callback
require('nvim-tree').setup{
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  open_on_tab         = false,
  auto_close          = false,
  hijack_cursor       = false,
  update_cwd          = false,
  lsp_diagnostics     = false,
  update_focused_file = {
    enable = false,
    update_cwd = false,
    ignore_list = {}
  },
  view = {
    width = 30,
    side = 'left',
    auto_resize = false,
    mappings = {
      custom_only = false,
      list = {
        { key = { 'l', '<CR>', 'o' }, cb = tree_cb 'edit' },
        { key = 'h', cb = tree_cb 'close_node' },
        { key = 'i', cb = tree_cb 'vsplit' },
        { key = '<Leader>f', cb = tree_cb 'close' },
      }
    }
  }
}

----------------------------------
-- Treesitter
----------------------------------
require('nvim-treesitter.configs').setup{
  highlight = {
    enable = true,
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ['foo.bar'] = 'Identifier',
    },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}  

----------------------------------
-- Toggleterm
----------------------------------
require('toggleterm').setup{
  -- size can be a number or function which is passed the current terminal
  size = function(term)
    if term.direction == 'horizontal' then
      return 20
    elseif term.direction == 'vertical' then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<c-\>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = false,
  shading_factor = 1, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  persist_size = true,
  -- direction = 'vertical' | 'horizontal' | 'window' | 'float',
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell,  -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = 'curved', -- 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
    width = math.floor(vim.api.nvim_win_get_width(0) * 0.9),
    height = math.floor(vim.api.nvim_win_get_height(0) * 0.9),
    winblend = 3,
    highlights = {
      border = 'Normal',
      background = 'Normal',
    }
  }
}

----------------------------------
-- Nvim-comment
----------------------------------
require('nvim_comment').setup{
  hook = function()
    if vim.api.nvim_buf_get_option(0, 'filetype') == 'cpp' then
      vim.api.nvim_buf_set_option(0, 'commentstring', '// %s')
    end
  end
}
