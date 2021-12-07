require('plugins')
require('settings')
require('key')

----------------------------------
-- Lualine & bufferline
----------------------------------
require('lualine').setup {
  options = { 
    theme = 'onedark', section_separators = {left = '', right = ''},
    component_separators = {left = '', right = ''},
    icons_enabled = false,
  },
  sections = {
    lualine_c = {function() return vim.fn.expand('%:p') end}
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
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  sources = {
    {name = 'nvim_lsp'},
    {name = 'buffer'},
    {name = 'path'},
    {name = 'vsnip'},
  },
  mapping = {
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'}),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  experimental = {
    ghost_text = true,
  }
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
          args = {'-'},
          stdin = true,
        }
      end
    },
    cpp = {
      function()
        return {
          exe = 'clang-format',
          args = {'--assume-filename', vim.api.nvim_buf_get_name(0), '--style', 'Chromium'},
          stdin = true,
          cwd = vim.fn.expand('%:p:h')
        }
      end
    },
    cmake = {
      function()
        return {
          exe = 'cmake-format',
          args = {'-'},
          stdin = true,
        }
      end,
    },
  }
})

-- Format on save
vim.api.nvim_exec([[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost *.py,*.h,*.cc,CMakeLists.txt silent! FormatWrite
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
        {key = {'l', '<CR>', 'o', 'e' }, cb = tree_cb('edit')},
        {key = 'h', cb = tree_cb('close_node')},
        {key = 'i', cb = tree_cb('vsplit')},
        {key = '<Leader>f', cb = tree_cb('close')},
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

----------------------------------
-- Smooth scroll
----------------------------------
require('neoscroll').setup({
    -- All these keys will be mapped to their corresponding default scrolling animation
    mappings = {'<C-u>', '<C-d>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
    hide_cursor = true,          -- Hide cursor while scrolling
    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
    use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = nil,       -- Default easing function
    pre_hook = nil,              -- Function to run before the scrolling animation starts
    post_hook = nil,             -- Function to run after the scrolling animation ends
})

----------------------------------
-- DAP
----------------------------------
local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-vscode', -- adjust as needed
  name = 'lldb'
}

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      local cmd = vim.fn.input('Launch command: ', vim.fn.getcwd() .. '/')
      myargs = {}
      for x in string.gmatch(cmd, "%S+") do
        table.insert(myargs, x)
      end
      program = myargs[1]
      table.remove(myargs, 1)
      return program
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = function()
      return myargs
    end,
    runInTerminal = false,
  },
}

require('dapui').setup({
  icons = {expanded = '▾', collapsed = '▸'},
  mappings = {
    -- Use a table to apply multiple mappings
    expand = {'<CR>', '<2-LeftMouse>'},
    open = 'o',
    remove = 'd',
    edit = 'e',
    repl = 'r',
  },
  sidebar = {
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with "id" and "size" keys
      {
        id = 'scopes',
        size = 0.25, -- Can be float or integer > 1
      },
      {id = 'breakpoints', size = 0.25},
      {id = 'stacks', size = 0.25},
      {id = 'watches', size = 00.25},
    },
    size = 40,
    position = 'left', -- Can be "left", "right", "top", "bottom"
  },
  tray = {
    elements = {'repl'},
    size = 10,
    position = 'bottom', -- Can be "left", "right", "top", "bottom"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    mappings = {
      close = {'q', '<Esc>'},
    },
  },
  windows = {indent = 1},
})
