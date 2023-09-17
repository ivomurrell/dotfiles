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
vim.cmd [[colorscheme tokyonight]]

vim.api.nvim_create_augroup('numbertoggle', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  callback = function()
    if vim.opt.number:get() and vim.api.nvim_get_mode().mode ~= 'i' then
      vim.opt.relativenumber = true
    end
  end,
  group = 'numbertoggle'
})
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  callback = function()
    if vim.opt.number:get() then
      vim.opt.relativenumber = false
    end
  end,
  group = 'numbertoggle'
})

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)


vim.keymap.set('n', '<space><space>',
  function()
    require('telescope.builtin').find_files({
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" } })
  end
)
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>*', require('telescope.builtin').grep_string)
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>ft', require('telescope.builtin').lsp_dynamic_workspace_symbols)
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags)

vim.keymap.set('n', 'ss', '<Plug>Sneak_s')
vim.keymap.set('n', 'SS', '<Plug>Sneak_S')
vim.keymap.set({ 'o', 'x' }, 'z', '<Plug>Sneak_s')
vim.keymap.set({ 'o', 'x' }, 'Z', '<Plug>Sneak_S')
vim.keymap.set('n', 'f', '<Plug>Sneak_f')
vim.keymap.set('n', 'F', '<Plug>Sneak_F')
vim.keymap.set('n', 't', '<Plug>Sneak_t')
vim.keymap.set('n', 'T', '<Plug>Sneak_T')

vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeToggle<cr>')
vim.keymap.set('n', '<leader>r', '<cmd>NvimTreeRefresh<cr>')
vim.keymap.set('n', '<leader>n', '<cmd>NvimTreeFindFile<cr>')

vim.keymap.set('n', '<leader>xx', '<cmd>TroubleToggle<cr>')
vim.keymap.set('n', '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>')
vim.keymap.set('n', '<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>')

vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
vim.keymap.set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })
