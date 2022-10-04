local default_options = {
  number = true, -- show number
  expandtab = true, -- expand tabs into spaces
  shiftwidth = 2, -- shift lines by 2 spaces
  tabstop = 2, -- 2 whitespaces for tabs visual presentation
  cursorline = true, -- highlight current row
  cursorcolumn = true, -- highlight current column
  scrolloff = 10, -- let 10 lines before/after cursor during scroll
  fileencoding = 'utf-8', -- the encoding written to a file
  termguicolors = true, -- set color
  splitbelow = true,
  splitright = true,
  clipboard = 'unnamedplus',
  swapfile = false,
  ignorecase = true,
  shell = 'zsh',
  mouse = 'v',
  so = 999, -- scroll with cursor centering
  cmdheight = 1,
}

for k, v in pairs(default_options) do
  vim.opt[k] = v
end

vim.g.floaterm_gitcommit = 'floaterm'
vim.g.floaterm_autoinsert = 1
vim.g.floaterm_width = 0.9
vim.g.floaterm_height = 0.9
vim.g.floaterm_wintitle = 0
vim.g.floaterm_autoclose = 1
vim.g.floaterm_shell = 'zsh'

vim.g.startify_change_to_vcs_root = 1
vim.g.startify_change_to_dir = 1

vim.cmd('colorscheme onedark')
vim.cmd('set background=dark')

-- vim.g.nvim_tree_respect_buf_cwd = 1
-- vim.g.nvim_tree_icons = {
--   -- default = '',
--   default = '',
--   symlink = '',
--   git = {
--     -- unstaged = '✗',
--     unstaged = '•',
--     staged = '✓',
--     unmerged = '',
--     renamed = '➜',
--     -- untracked = '★',
--     untracked = '✗',
--     deleted = '',
--     ignored = '◌',
--   },
--   folder = {
--     arrow_open = '',
--     arrow_closed = '',
--     default = '',
--     open = '',
--     empty = '',
--     empty_open = '',
--     symlink = '',
--     symlink_open = '',
--   },
--   lsp = {
--     hint = '',
--     info = '',
--     warning = '',
--     error = '',
--   },
-- }
