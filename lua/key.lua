local function map(mode, key, action, opts)
  opts = vim.tbl_extend('keep', opts or {}, {noremap = true, silent = true, expr = false})
  vim.api.nvim_set_keymap(mode, key, action, opts)
end

local function plugmap(mode, key, action, opts)
  opts = vim.tbl_extend('keep', opts or {}, {noremap = not vim.startswith(action, '<Plug>')})
  map(mode, key, action, opts)
end

----------------------
-- General settings
----------------------
-- Map the leader key
map('n', '<Space>', '', {})
vim.g.mapleader = ' '

-- ESC to clear search highlight & save
map('n', '<ESC>', ':w|nohlsearch<CR>')

-- Save while existing insert mode
map('i', '<ESC>', '<ESC>:w<CR>')

-- Map 1 to reformat
map('n', '1', ':Format<CR>')

-- Map 2 to toggle float term
map('n', '2', ':ToggleTerm dir=./ direction=float<CR>')

-- Map q to exit
map('n', 'q', ':exit<CR>')

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
map('n', '<Leader>bw', ':<c-u>bp <bar> bd #<CR>')  -- quit current buffer
map('n', '<Leader>bo', ':BufOnly<CR>')             -- only contain current buffer

vim.cmd([[imap <expr> <c-l> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<c-l>']])
vim.cmd([[smap <expr> <c-l> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<c-l>']])
vim.cmd([[imap <expr> <c-h> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-prev)' : '<c-h>']])
vim.cmd([[smap <expr> <c-h> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-prev)' : '<c-h>']])

----------------------
-- Accelerated-jk
----------------------
plugmap('n', 'j', '<Plug>(accelerated_jk_gj)')
plugmap('n', 'k', '<Plug>(accelerated_jk_gk)')

----------------------
-- Easymotion
----------------------
plugmap('n', 's' , '<Plug>(easymotion-s2)')
plugmap('n', 'f' , '<Plug>(easymotion-sl)')

----------------------
-- Toggleterm
----------------------
map('t', '<ESC>', [[<C-\><C-n>]])
map('n', 'tb', ':ToggleTerm dir=./ direction=horizontal<CR>')
map('n', 'tr', ':ToggleTerm dir=./ direction=vertical<CR>')
map('n', 'tf', ':ToggleTerm dir=./ direction=float<CR>')
map('n', 'tt', ':ToggleTerm dir=./ direction=float<CR>')

local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ 
  cmd = 'lazygit', 
  direction='float', 
  hidden = true ,
  float_opts = {
    border = 'curved',
    width = math.floor(vim.api.nvim_win_get_width(0) * 0.9),
    height = math.floor(vim.api.nvim_win_get_height(0) * 0.9),
  },
})
function lazygit_toggle()
  lazygit:toggle()
end
map('n', 'zg', ':lua lazygit_toggle()<CR>')

----------------------
-- Telescope
----------------------
map('n', '<c-f>', ':Telescope find_files<CR>')
map('n', '<c-g>', ':Telescope live_grep<CR>')

----------------------
-- Comment
----------------------
map('n', '<Leader>c', ':CommentToggle<CR>')
map('v', '<Leader>c', ':CommentToggle<CR>')

----------------------
-- SnipRun
----------------------
map('n', '<Leader>g', 'ggVG:SnipRun<CR>')

----------------------
-- Nvim-tree
----------------------
function tree_find()
  local view = require'nvim-tree.view'
  if view.win_open() then
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
map('n', '<Leader>f', ':lua tree_find()<CR>')
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
map('n', 'B', ":lua require('dap').toggle_breakpoint()<CR>")
map('n', '<F2>', ':lua debug_stop()<CR>')
map('n', '<F5>', ':lua debug_start()<CR>')
map('n', '<F10>', ":lua require('dap').step_over()<CR>")
map('n', '<F11>', ":lua require('dap').step_into()<CR>")
map('n', '<F12>', ":lua require('dap').step_out()<CR>")
