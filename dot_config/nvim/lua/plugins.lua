require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'                        -- Package manager
  use { 'lewis6991/impatient.nvim', disable = false } -- Implements caching to speed up startup
  use 'neovim/nvim-lspconfig'                         -- Collection of configurations for the built-in LSP client
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup {
        sources = {
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.diagnostics.cfn_lint,
          null_ls.builtins.formatting.prettier
        }
      }
    end
  } -- add LSP support for non-LSP tools
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { "typescript", "javascript", "lua", "rust" },
        highlight = {
          enable = true
        },
        textobjects = {
          select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["as"] = "@statement.outer",
              ["a?"] = "@conditional.outer",
              ["i?"] = "@conditional.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ia"] = "@parameter.inner",
              ["aa"] = "@parameter.outer",
            },
          }
        },
        matchup = {
          enable = true
        }
      }
    end
  }                                                 -- Better/faster syntax highlighting with treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects' -- Add treesitter groups as textobjects
  use 'andymass/vim-matchup'                        -- Improve %-jumping with treesitter integration
  use 'folke/tokyonight.nvim'                       -- Colour scheme that supports other plugins
  use 'tpope/vim-commentary'                        -- Comment out lines
  use 'tpope/vim-sleuth'                            -- Detect indentation
  use 'tpope/vim-unimpaired'                        -- [ and ] shortcuts
  use { 'tpope/vim-fugitive', disable = true }      -- Git plugin
  use { 'tpope/vim-rhubarb', disable = true }       -- GitHub support for fugitive.vim
  use 'machakann/vim-highlightedyank'               -- Highlight line when yanking
  use 'machakann/vim-sandwich'                      -- Add surroundings to text objects
  use 'justinmk/vim-sneak'                          -- Jump to location with two characters
  use 'tommcdo/vim-lion'                            -- Aligning text
  use {
    'windwp/nvim-autopairs',
    config = function()
      require("nvim-autopairs").setup {}
    end
  } -- Insert closing characters for pairs
  use {
    'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup {}
    end
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      local function indentation()
        local indent_type = vim.opt.expandtab:get() and 'spaces' or 'tabs'
        return indent_type .. ': ' .. vim.opt.shiftwidth:get()
      end

      require('lualine').setup {
        sections = {
          lualine_c = { { 'filename', path = 1 } },
          lualine_x = { indentation, 'filetype' },
        },
        extensions = { 'fugitive', 'nvim-tree' }
      }
    end
  }                             -- Customisable status line
  use 'lewis6991/gitsigns.nvim' -- Pretty git gutter and in-line blame
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    tag = 'nightly',
    -- keys = { '<C-n>', '<leader>n' },
    config = function()
      require('nvim-tree').setup {
        actions = {
          open_file = {
            quit_on_open = true
          }
        }
      }
    end
  } -- Graphical file explorer
  use {
    'akinsho/bufferline.nvim',
    tag = "v2.*",
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('bufferline').setup {}
    end
  }                              -- Tabs in a buffer line
  use { 'ojroques/nvim-bufdel' } -- Don't close window when deleting buffers
  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('trouble').setup {}
    end
  }                                                                                      -- List diagnositic errors
  use { 'mfussenegger/nvim-dap', disable = true }                                        -- Debugging tooling
  use { 'rcarriga/nvim-dap-ui', disable = true, requires = { 'mfussenegger/nvim-dap' } } -- UI for debugging
  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = { 'nvim-lua/plenary.nvim', 'kyazdani42/nvim-web-devicons' },
  } -- Fuzzy search for various lists such as project files
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  } -- Use fzf for searching with telescope
  use {
    'TimUntersberger/neogit',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('neogit').setup {}
    end
  } -- Magit clone for Neovim
  use {
    'mhartington/formatter.nvim',
    disable = true,
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'rust' },
    config = function()
      local prettier_files = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }
      local prettier_config = {}
      for _, ft in pairs(prettier_files) do
        prettier_config[ft] = { require('formatter.filetypes.' .. ft).prettier }
      end
      local rust_fmt = require('formatter.filetypes.rust').rustfmt()
      rust_fmt.args = { "--edition=2021" }
      prettier_config['rust'] = { function()
        return rust_fmt
      end }
      require('formatter').setup {
        filetype = prettier_config
      }
    end
  } -- Format source files
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',                -- Use LSP for autocompletion
      'L3MON4D3/LuaSnip',                    -- Snippet engine
      'hrsh7th/cmp-nvim-lsp-signature-help', -- View function signature when filling parameters
      'hrsh7th/cmp-buffer',                  -- Autocompletion for strings in buffer
      'hrsh7th/cmp-path',                    -- Autocompletion for file paths
      'hrsh7th/cmp-cmdline',                 -- Autocompletion for vim's cmdline
      {
        'David-Kunz/cmp-npm',
        requires = {
          'nvim-lua/plenary.nvim'
        }
      } -- Autocompletion for npm packages
    },
    config = function()
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      if (cmp) then
        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'nvim_lsp_signature_help' },
            { name = 'buffer' },
            { name = 'path' },
            {
              name = 'npm',
              keyword_length = 4
            }
          })
        })
        cmp.setup.cmdline('/', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' }
          }
        })
        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          })
        })
      end
    end
  }                             -- Code autocompletion
  use 'stevearc/dressing.nvim'  -- Make input windows nicer
  use 'smerrill/vcl-vim-plugin' -- VCL syntax support
end)
