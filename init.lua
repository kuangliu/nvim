require('plugins')
require('settings')
require('key')

----------------------------------
-- Lualine & bufferline
----------------------------------
require('lualine').setup({
  options = {
    theme = 'onedark',
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    icons_enabled = false,
    globalstatus = true,
  },
  extensions = { 'nvim-tree', 'toggleterm' },
  sections = {
    lualine_c = {
      {
        'filename',
        path = 2,
      },
    },
  },
})

require('bufferline').setup({
  options = {
    indicator = { icon = '' },
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
      bg = '#282C34',
    },
    background = {
      fg = '#778899',
      bg = '#282C34',
      bold = true,
    },
    tab_close = {
      bg = '#282C34',
    },
    separator = {
      fg = '#282C34',
      bg = '#282C34',
    },
    buffer_selected = {
      fg = '#282C34',
      bg = '#778899',
      bold = true,
    },
    modified_selected = {
      fg = '#282C34',
      bg = '#778899',
      bold = true,
    },
    duplicate_selected = {
      fg = '#282C34',
      bg = '#778899',
      italic = true,
    },
    duplicate_visible = {
      bg = '#282C34',
      fg = '#778899',
      italic = true,
    },
    duplicate = {
      bg = '#282C34',
      fg = '#778899',
      italic = true,
    },
  },
})

----------------------------------
-- Nvim-cmp
----------------------------------
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local cmp = require('cmp')
local luasnip = require('luasnip')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  sources = {
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  },
  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
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

    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  },
  experimental = {
    ghost_text = true,
  },
})

----------------------------------
-- LuaSnip
----------------------------------
require('luasnip.loaders.from_vscode').load()

----------------------------------
-- LSP
----------------------------------
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true }

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

nvim_lsp['pyright'].setup({
  on_attach = on_attach,
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
})

nvim_lsp['clangd'].setup({
  on_attach = on_attach,
})

nvim_lsp.rust_analyzer.setup({
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
        }
    }
})

----------------------------------
-- Formatter
----------------------------------
require('formatter').setup({
  filetype = {
    python = {
      function()
        return {
          exe = 'autopep8',
          args = { '--max-line-length', 120, '-' },
          stdin = true,
        }
      end,
    },
    cpp = {
      function()
        return {
          exe = 'clang-format',
          args = { '--assume-filename', vim.api.nvim_buf_get_name(0), '--style', 'Chromium' },
          stdin = true,
          cwd = vim.fn.getcwd(),
        }
      end,
    },
    rust = {
      function()
        return {
          exe = 'rustfmt',
          args = { ' ' },
          stdin = true,
        }
      end,
    },
    cmake = {
      function()
        return {
          exe = 'cmake-format',
          args = { '-' },
          stdin = true,
        }
      end,
    },
    lua = {
      function()
        return {
          exe = 'stylua',
          args = { '--indent-type Spaces --indent-width 2 --quote-style AutoPreferSingle -' },
          stdin = true,
        }
      end,
    },
  },
})

-- Format on save
-- vim.api.nvim_exec([[
--   augroup FormatAutogroup
--     autocmd!
--     autocmd BufWritePost *.py,*.h,*.cc,CMakeLists.txt silent! FormatWrite
--   augroup END
--   ]], true)

-- Auto Run
-- vim.api.nvim_exec([[
--   augroup RunFile
--     autocmd BufEnter *.py let @g=":w\<CR> :TermExec direction=vertical cmd='python3 %'\<CR>"
--     autocmd BufEnter *.cc let @g=":w\<CR> :TermExec direction=vertical cmd='g++ -std=c++11 -O2 -Wall % && ./a.out'\<CR>"
--   augroup END
-- ]], true)

----------------------------------
-- Nvim-tree
----------------------------------
local my_close_node = function(node)
  local view = require('nvim-tree.view')
  local renderer = require('nvim-tree.renderer')
  local core = require('nvim-tree.core')
  local utils = require('nvim-tree.utils')

  local fs_stat = node.fs_stat
  local parent = node.parent
  if fs_stat.type == 'directory' and node.open then
    parent = node
  end

  if not parent or parent.cwd then
    return view.set_cursor({ 1, 0 })
  end

  local _, line = utils.find_node(core.get_explorer().nodes, function(n)
    return n.absolute_path == parent.absolute_path
  end)

  view.set_cursor({ line + 1, 0 })
  parent.open = false
  renderer.draw()
end

require('nvim-tree').setup({
  view = {
    width = 30,
    side = 'left',
    mappings = {
      custom_only = false,
      list = {
        { key = { 'l', '<CR>', 'o', 'e' }, action = 'edit' },
        { key = 'h', action = 'my_close_node', action_cb = my_close_node },
        { key = 'i', action = 'vsplit' },
      },
    },
  },
  filters = {
    dotfiles = true,
    custom = {},
    exclude = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 400,
  },
  renderer = {
    icons = {
      webdev_colors = false,
      git_placement = 'before',
      padding = ' ',
      symlink_arrow = ' ➜ ',
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        -- default = '',
        default = '',
        symlink = '',
        bookmark = '',
        folder = {
          arrow_closed = '',
          arrow_open = '',
          default = '',
          open = '',
          empty = '',
          empty_open = '',
          symlink = '',
          symlink_open = '',
        },
        git = {
          -- unstaged = '✗',
          unstaged = '•',
          staged = '✓',
          unmerged = '',
          renamed = '➜',
          -- untracked = '★',
          untracked = '✗',
          deleted = '',
          ignored = '◌',
        },
      },
    },
  },
})

----------------------------------
-- Treesitter
----------------------------------
require('nvim-treesitter.configs').setup({
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
})

----------------------------------
-- Toggleterm
----------------------------------
require('toggleterm').setup({
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
  shell = vim.o.shell, -- change the default shell
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
    },
  },
})

----------------------------------
-- Nvim-comment
----------------------------------
require('nvim_comment').setup({
  hook = function()
    if vim.api.nvim_buf_get_option(0, 'filetype') == 'cpp' then
      vim.api.nvim_buf_set_option(0, 'commentstring', '// %s')
    end
  end,
})

----------------------------------
-- Smooth scroll
----------------------------------
require('neoscroll').setup({
  -- All these keys will be mapped to their corresponding default scrolling animation
  mappings = { '<C-u>', '<C-d>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
  hide_cursor = true, -- Hide cursor while scrolling
  stop_eof = true, -- Stop at <EOF> when scrolling downwards
  use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
  respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  easing_function = nil, -- Default easing function
  pre_hook = nil, -- Function to run before the scrolling animation starts
  post_hook = nil, -- Function to run after the scrolling animation ends
})

----------------------------------
-- Session Manager
----------------------------------
local Path = require('plenary.path')
require('session_manager').setup({
  sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'),
  path_replacer = '__',
  colon_replacer = '++',
  autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
  autosave_last_session = true,
  autosave_ignore_not_normal = true,
  autosave_ignore_filetypes = {
    'gitcommit',
  },
  autosave_only_in_session = false,
  max_path_length = 80,
})

local config_group = vim.api.nvim_create_augroup('MyConfigGroup', {}) -- A global group for all your config autocommands
vim.api.nvim_create_autocmd({ 'SessionLoadPost' }, {
  group = config_group,
  callback = function()
    require('nvim-tree').toggle(true, true)
  end,
})

----------------------------------
-- Telescope
----------------------------------
require('telescope').setup({
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown({}),
    },
  },
})
require('telescope').load_extension('ui-select')

----------------------------------
-- Aerial
----------------------------------
require('aerial').setup({
  width = 30,
})

----------------------------------
-- DAP
----------------------------------
local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-vscode', -- adjust as needed
  name = 'lldb',
}

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      local cmd = vim.fn.input('Launch command: ', vim.fn.getcwd() .. '/')
      myargs = {}
      for x in string.gmatch(cmd, '%S+') do
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
  icons = { expanded = '▾', collapsed = '▸' },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { '<CR>', '<2-LeftMouse>' },
    open = 'o',
    remove = 'd',
    edit = 'e',
    repl = 'r',
    toggle = 't',
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has('nvim-0.7'),
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        { id = 'scopes', size = 0.25 },
        'breakpoints',
        'stacks',
        'watches',
      },
      size = 40, -- 40 columns
      position = 'left',
    },
    {
      elements = {
        'repl',
        'console',
      },
      size = 0.25, -- 25% of total lines
      position = 'bottom',
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = 'single', -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { 'q', '<Esc>' },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
  },
})
