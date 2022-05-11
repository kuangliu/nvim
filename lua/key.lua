local function map(mode, key, action)
  vim.keymap.set(mode, key, action, { silent = true })
end

----------------------
-- General settings
----------------------
-- Map the leader key
vim.g.mapleader = ' '

-- ESC to clear search highlight & save
map('n', '<ESC>', ':w|nohlsearch<CR>')

-- Save while existing insert mode
map('i', '<ESC>', '<ESC>:w<CR>')

-- Map 1 to reformat
map('n', '1', ':Format<CR>')

-- Map 2 to toggle float term
map('n', '2', ':ToggleTerm dir=./ direction=float<CR>')

-- Map q/Q to exit/quit
map('n', 'q', ':exit<CR>')
map('n', 'Q', ':wqa!<CR>')

-- Delete from line start to end of previous line
map('n', '<Leader>dk', '^hvk$d<CR>')

-- Delete from cursor to end of previsou line
map('n', 'dk', 'vk$d')

-- Move current line up and down
map('n', '<c-k>', ':move -2<CR>')
map('n', '<c-j>', ':move +1<CR>')

-- Fix indent blocks
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Copy to clipboard
map('v', '<Leader>y', '"+y')

-- Replace word under cursor
-- map('n', '<Leader>r', ':%s/\\<<c-r><c-w>\\>//g<left><left>', { silent=false })

-- CMake
map('n', '@b', ':!cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && cmake --build build<CR>')
map('n', '@g', ':!./build/main<CR>')

----------------------
-- Window settings
----------------------
map('n', '<s-l>', ':vertical resize -5<CR>')
map('n', '<s-h>', ':vertical resize +5<CR>')
map('n', '<s-k>', ':resize +5<CR>')
map('n', '<s-j>', ':resize -5<CR>')

----------------------
-- Terminal settings
----------------------
map('n', '<Leader>h', ':wincmd h<CR>')
map('n', '<Leader>j', ':wincmd j<CR>')
map('n', '<Leader>k', ':wincmd k<CR>')
map('n', '<Leader>l', ':wincmd l<CR>')

----------------------
-- Tab settings
----------------------
map('n', '<TAB>', ':bn<CR>')
map('n', ']b', ':bn<CR>')
map('n', '[b', ':bp<CR>')
map('n', '<Leader>bw', ':<c-u>bp <bar> bd #<CR>') -- quit current buffer
map('n', '<Leader>bo', ':BufOnly<CR>') -- only contain current buffer

-- Move current buffer vsp
function move_buf_vsp()
  -- If current buffer is the only buffer, return
  local num_buffers = #vim.fn.getbufinfo({ buflisted = 1 })
  if num_buffers == 1 then
    return
  end
  local file_path = vim.fn.expand('%:p') -- get current file path
  vim.cmd([[bp | bd #]]) -- close current buffer
  vim.cmd('vsp ' .. file_path) -- reopen in vsp
end
map('n', '<Leader>br', move_buf_vsp)

----------------------
-- Accelerated-jk
----------------------
map('n', 'j', '<Plug>(accelerated_jk_gj)')
map('n', 'k', '<Plug>(accelerated_jk_gk)')

----------------------
-- Easymotion
----------------------
map('n', 's', '<Plug>(easymotion-s2)')
map('n', 'f', '<Plug>(easymotion-sl)')

----------------------
-- Toggleterm
----------------------
map('t', '<ESC>', [[<C-\><C-n>]])
map('n', 'tb', ':ToggleTerm dir=./ direction=horizontal<CR>')
map('n', 'tr', ':ToggleTerm dir=./ direction=vertical<CR>')
map('n', 'tf', ':ToggleTerm dir=./ direction=float<CR>')
map('n', 'tt', ':ToggleTerm dir=./ direction=float<CR>')

local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({
  cmd = 'lazygit',
  direction = 'float',
  hidden = true,
  float_opts = {
    border = 'curved',
    width = math.floor(vim.api.nvim_win_get_width(0) * 0.9),
    height = math.floor(vim.api.nvim_win_get_height(0) * 0.9),
  },
})
function lazygit_toggle()
  lazygit:toggle()
end
map('n', 'zg', lazygit_toggle)

----------------------
-- Telescope
----------------------
map('n', '<c-f>', ':Telescope find_files<CR>')
map('n', '<c-g>', ':Telescope live_grep<CR>')

----------------------
-- Session Manager
----------------------
map('n', '<c-p>', ':SessionManager load_session<CR>')
map('n', '<Leader>sa', ':SessionManager save_current_session<CR>')
map('n', '<Leader>sd', ':SessionManager delete_session<CR>')

----------------------
-- Comment
----------------------
map('n', '<Leader>c', ':CommentToggle<CR>')
map('v', '<Leader>c', ':CommentToggle<CR>')

----------------------
-- Aerial
----------------------
map('n', '<Leader>o', ':AerialToggle<CR>')
map('n', '[[', ':AerialPrev<CR>')
map('n', ']]', ':AerialNext<CR>')

----------------------
-- Nvim-tree
----------------------
function tree_find()
  local view = require('nvim-tree.view')
  if view.is_visible() then
    view.close()
  else
    local buf = vim.api.nvim_buf_get_name(0)
    if string.len(buf) == 0 then
      require('nvim-tree').toggle(false)
    else
      require('nvim-tree').find_file(true)
    end
  end
end
map('n', '<Leader>f', tree_find)
map('n', '<S-r>', ':NvimTreeRefresh<CR>')

----------------------
-- DAP
----------------------
function debug_start()
  require('dapui').open()
  require('dap').continue()
end
function debug_stop()
  require('dapui').close()
  require('dap').close()
end
map('n', 'B', require('dap').toggle_breakpoint)
map('n', '<F2>', debug_stop)
map('n', '<F5>', debug_start)
map('n', '<F10>', require('dap').step_over)
map('n', '<F11>', require('dap').step_into)
map('n', '<F12>', require('dap').step_out)
