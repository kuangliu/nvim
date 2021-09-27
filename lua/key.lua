local function map(mode, key, action, opts)
  opts = vim.tbl_extend("keep", opts or {}, { noremap = true, silent = true, expr = false })
  vim.api.nvim_set_keymap(mode, key, action, opts)
end

local function plugmap(mode, key, action, opts)
  opts = vim.tbl_extend("keep", opts or {}, { noremap = not vim.startswith(action, "<Plug>") })
  map(mode, key, action, opts)
end

-- map the leader key
map('n', '<Space>', '', {})
vim.g.mapleader = ' '

-- ESC to clear search highlight
map('n', '<ESC>', ':nohlsearch<CR>')

-- Map 1 to save
map('n', '1', ':w<CR>')

-- Map q to exit
map('n', 'q', ':exit<CR>')

-- Delete from line start to end of previous line
map('n', '<Leader>d', '^hvk$d<CR>')

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
map('n', '<Leader>r', ':%s/\\<<c-r><c-w>\\>//g<left><left>', { silent=false })

-- Terminal settings
map('n', '<Leader>h', ':wincmd h<CR>')
map('n', '<Leader>j', ':wincmd j<CR>')
map('n', '<Leader>k', ':wincmd k<CR>')
map('n', '<Leader>l', ':wincmd l<CR>')

-- Tab settings
map('n', '<TAB>', ':bn<CR>')
map('n', ']b', ':bn<CR>')
map('n', '[b', ':bp<CR>')
map('n', '<Leader>bw', ':<c-u>bp <bar> bd #<CR>')  -- quit current buffer
map('n', '<Leader>bo', ':BufOnly<CR>')             -- only contain current buffer

-- Repalace jk with Accelerated-jk
plugmap('n', 'j', '<Plug>(accelerated_jk_gj)')
plugmap('n', 'k', '<Plug>(accelerated_jk_gk)')

-- Easymotion
plugmap('n', 's' , '<Plug>(easymotion-s2)')
plugmap('n', 'f' , '<Plug>(easymotion-sl)')

-- Floaterm
map('n', '2', ':FloatermToggle<CR>')
map('t', '<ESC>', '<C-\\><C-n>')  -- leave nvim terminal mode
map('n', 'tf', ':FloatermNew<CR>')
map('n', 'tt', ':FloatermToggle<CR>')
map('n', 'tr', ':FloatermNew --position=right --height=1 --width=0.4 --wintype=vsplit<CR>')
map('n', 'tb', ':FloatermNew --position=bottom --height=0.4 --width=1 --wintype=normal<CR>')
map('n', 'zg', ':FloatermNew lazygit<CR>')
map('n', 'du', ':FloatermNew ncdu<CR>')

-- Telescope
map('n', '<c-f>', ':Telescope find_files<CR>')
map('n', '<c-g>', ':Telescope live_grep<CR>')

-- Comment
map('n', '<Leader>c', ':CommentToggle<CR>')
map('v', '<Leader>c', ':CommentToggle<CR>')

-- Nvim-tree
my_tree_find = function()
  local view = require'nvim-tree.view'
  if view.win_open() then
    view.close()
  else
    require'nvim-tree'.find_file(true)
  end
end
--map('n', '<Leader>f', ':NvimTreeFindFile<CR>')
map('n', '<Leader>f', ':lua my_tree_find()<CR>')
map('n', '<S-r>', ':NvimTreeRefresh<CR>')

