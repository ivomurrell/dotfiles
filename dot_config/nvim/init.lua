require('plugins')

vim.opt.mouse = 'a'
vim.opt.updatetime = 100
vim.opt.number = true
vim.opt.signcolumn = 'yes'
vim.opt.undofile = true
vim.opt.termguicolors = true
vim.cmd [[colorscheme tokyonight]]

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)

  local function organizeImports()
    vim.lsp.buf.execute_command({
      command = "_typescript.organizeImports",
      arguments = { vim.api.nvim_buf_get_name(bufnr) }
    })
  end

  vim.keymap.set('n', '<space>co', organizeImports, bufopts)

  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local float_opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, float_opts)
    end
  })

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      callback = vim.lsp.buf.document_highlight,
      buffer = bufnr,
      group = "lsp_document_highlight",
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      callback = vim.lsp.buf.clear_references,
      buffer = bufnr,
      group = "lsp_document_highlight",
    })
  end
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'rust_analyzer', 'tsserver' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup({
    on_attach = on_attach,
  })
end
require('lspconfig').sumneko_lua.setup({
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})
require('lspconfig').eslint.setup {}

require('gitsigns').setup {
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text_pos = 'right_align',
    delay = 400
  },
  on_attach = function(bufnr)
    vim.keymap.set('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() require('gitsigns').next_hunk() end)
      return '<Ignore>'
    end, { buffer = bufnr, expr = true })
    vim.keymap.set('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() require('gitsigns').prev_hunk() end)
      return '<Ignore>'
    end, { buffer = bufnr, expr = true })

    vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk)
    vim.keymap.set('n', '<leader>tb', require('gitsigns').toggle_current_line_blame)

    vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}

require('telescope').load_extension('fzf')
vim.keymap.set('n', '<space><space>', require('telescope.builtin').find_files)
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>*', require('telescope.builtin').grep_string)
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>ft', require('telescope.builtin').lsp_dynamic_workspace_symbols)
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags)

vim.keymap.set('n', '<Leader>s', '<Plug>Sneak_s')
vim.keymap.set('n', '<Leader>S', '<Plug>Sneak_S')
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
