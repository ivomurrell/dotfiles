-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion
  if client:supports_method('textDocument/completion') then
    local chars = { ' ', '.' };
    for i = 65, 90 do table.insert(chars, string.char(i)) end
    for i = 97, 122 do table.insert(chars, string.char(i)) end

    client.server_capabilities.completionProvider.triggerCharacters = chars
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  end

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)

  local function organizeImports()
    vim.lsp.buf.execute_command({
      command = "_typescript.organizeImports",
      arguments = { vim.api.nvim_buf_get_name(bufnr) }
    })
  end

  vim.keymap.set('n', '<space>co', organizeImports, bufopts)

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      callback = vim.lsp.buf.document_highlight,
      buffer = bufnr,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      callback = vim.lsp.buf.clear_references,
      buffer = bufnr,
    })
  end
end

return {
  'neovim/nvim-lspconfig',
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require('lspconfig').ts_ls.setup({
      on_attach = on_attach,
      root_dir = require('lspconfig').util.find_package_json_ancestor,
      single_file_support = false,
      init_options = {
        hostInfo = 'neovim',
        preferences = {
          disableSuggestions = true
        }
      }
    })
    require('lspconfig').denols.setup({
      on_attach = on_attach,
      root_dir = require('lspconfig').util.root_pattern("deno.json", "deno.jsonc"),
    })
    vim.g.markdown_fenced_lanuages = {
      "ts=typescript"
    }
    require('lspconfig').rust_analyzer.setup({
      on_attach = on_attach,
      settings = {
        ['rust-analyzer'] = {
          checkOnSave = {
            command = 'clippy'
          }
        }
      }
    })
    require('lspconfig').lua_ls.setup({
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
            checkThirdParty = false
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    })
    require('lspconfig').r_language_server.setup({
      on_attach = on_attach,
    })
    require('lspconfig').eslint.setup {
    }
  end
} -- Collection of configurations for the built-in LSP client
