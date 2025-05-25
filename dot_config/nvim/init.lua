vim.loader.enable()

vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
require('lazy').setup('plugins')

vim.opt.mouse = 'a'
vim.opt.updatetime = 100
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.signcolumn = 'yes'
vim.opt.undofile = true
vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.winborder = 'rounded'
vim.opt.completeopt:append({ 'fuzzy', 'noinsert', 'preview' })
vim.cmd [[colorscheme tokyonight-storm]]

vim.diagnostic.config({ virtual_lines = true })

vim.api.nvim_create_augroup('numbertoggle', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  callback = function()
    if vim.o.number and vim.api.nvim_get_mode().mode ~= 'i' then
      vim.o.relativenumber = true
    end
  end,
  group = 'numbertoggle'
})
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  callback = function()
    if vim.o.number then
      vim.o.relativenumber = false
    end
  end,
  group = 'numbertoggle'
})

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
vim.keymap.set('i', 'jj', '<Esc>', opts)
