vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.o.swapfile = false

vim.opt.list = false
vim.opt.number = true
vim.opt.mouse = 'a'

vim.opt.relativenumber = true
vim.opt.showmode = false

vim.diagnostic.config { jump = { float = true } }

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

vim.opt.guicursor = 'n-v-c:block'
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard', noremap = true })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard', noremap = true })

vim.keymap.set('x', 'p', '"_dP')

vim.opt.breakindent = true

vim.opt.undofile = true
vim.opt.termguicolors = true
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'
vim.opt.isfname:append '@-@'
-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>qq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Quickfix navigation
-- vim.keymap.set('n', '<A-]>', ':cnext<CR>', { desc = 'Next quickfix item' })
-- vim.keymap.set('n', '<A-[>', ':cprev<CR>', { desc = 'Previous quickfix item' })

vim.keymap.set('n', '<A-]>', function()
  if #vim.fn.getloclist(0) > 0 then
    vim.cmd 'lnext'
  elseif #vim.fn.getqflist() > 0 then
    vim.cmd 'cnext'
  end
end)

vim.keymap.set('n', '<A-[>', function()
  if #vim.fn.getloclist(0) > 0 then
    vim.cmd 'lprev'
  elseif #vim.fn.getqflist() > 0 then
    vim.cmd 'cprev'
  end
end)

-- vim.keymap.set('n', '<leader>e', function()
--   vim.cmd 'Ex'
-- end, { desc = 'Open Netrw' })

vim.keymap.set('n', '<Leader>e', '<cmd>Oil<CR>', { desc = 'Open Oil file explorer' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
