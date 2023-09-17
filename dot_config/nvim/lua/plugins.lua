return {
  'folke/lazy.nvim',                               -- Package manager
  { 'lewis6991/impatient.nvim', enabled = false }, -- Implements caching to speed up startup
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },
  'neovim/nvim-lspconfig', -- Collection of configurations for the built-in LSP client
  {
    'jose-elias-alvarez/null-ls.nvim',
    enabled = false,
    dependencies = { 'nvim-lua/plenary.nvim' },
  }, -- add LSP support for non-LSP tools
  {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = true,
  }, -- show LSP loading progress
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
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
              ["i/"] = "@regex.inner",
              ["a/"] = "@regex.outer",
            },
          }
        },
        matchup = {
          enable = true
        }
      }
    end
  },                                                 -- Better/faster syntax highlighting with treesitter
  'nvim-treesitter/nvim-treesitter-textobjects',     -- Add treesitter groups as textobjects
  'andymass/vim-matchup',                            -- Improve %-jumping with treesitter integration
  'folke/tokyonight.nvim',                           -- Colour scheme that supports other plugins
  'tpope/vim-commentary',                            -- Comment out lines
  'tpope/vim-sleuth',                                -- Detect indentation
  'tpope/vim-unimpaired',                            -- [ and ] shortcuts
  'tpope/vim-fugitive',                              -- Git plugin
  { 'tpope/vim-rhubarb',        enabled = false },   -- GitHub support for fugitive.vim
  'machakann/vim-highlightedyank',                   -- Highlight line when yanking
  'machakann/vim-sandwich',                          -- Add surroundings to text objects
  'justinmk/vim-sneak',                              -- Jump to location with two characters
  'chrisgrieser/nvim-spider',                        -- Respect CamelCase with word motions
  'tommcdo/vim-lion',                                -- Aligning text
  'romainl/vim-cool',                                -- Disables search highlighting once I'm done
  { 'windwp/nvim-autopairs',        config = true }, -- Insert closing characters for pairs
  { 'kyazdani42/nvim-web-devicons', lazy = true,  config = true },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
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
  },                         -- Customisable status line
  'lewis6991/gitsigns.nvim', -- Pretty git gutter and in-line blame
  {
    'kyazdani42/nvim-tree.lua',
    dependencies = 'kyazdani42/nvim-web-devicons',
    cmd = { 'NvimTreeToggle', 'NvimTreeFindFile' },
    opts = { actions = { open_file = { quit_on_open = true } } }
  }, -- Graphical file explorer
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = true
  },                          -- Tabs in a buffer line
  { 'ojroques/nvim-bufdel' }, -- Don't close window when deleting buffers
  {
    'folke/trouble.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = true
  },                                                                                        -- List diagnositic errors
  { 'mfussenegger/nvim-dap', enabled = false },                                             -- Debugging tooling
  { 'rcarriga/nvim-dap-ui',  enabled = false, dependencies = { 'mfussenegger/nvim-dap' } }, -- UI for debugging
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'kyazdani42/nvim-web-devicons' },
  }, -- Fuzzy search for various lists such as project files
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  }, -- Use fzf for searching with telescope
  {
    'TimUntersberger/neogit',
    enabled = false,
    dependencies = 'nvim-lua/plenary.nvim',
    config = true
  }, -- Magit clone for Neovim
  {
    'mhartington/formatter.nvim',
    enabled = false,
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'rust' },
    config = function()
      local prettier_files = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }
      local prettier_config = {}
      for _, ft in pairs(prettier_files) do
        prettier_config[ft] = { require('formatter.filetypes.' .. ft).prettier }
      end
      local rust_fmt = require('formatter.filetypes.rust').rustfmt()
      rust_fmt.args = { ",--edition=2021" }
      prettier_config['rust'] = { function()
        return rust_fmt
      end }
      require('formatter').setup {
        filetype = prettier_config
      }
    end
  }, -- Format source files
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',                -- Use LSP for autocompletion
      'L3MON4D3/LuaSnip',                    -- Snippet engine
      'hrsh7th/cmp-nvim-lsp-signature-help', -- View function signature when filling parameters
      'hrsh7th/cmp-buffer',                  -- Autocompletion for strings in buffer
      'hrsh7th/cmp-path',                    -- Autocompletion for file paths
      'hrsh7th/cmp-cmdline',                 -- Autocompletion for vim's cmdline
      {
        'David-Kunz/cmp-npm',
        dependencies = {
          'nvim-lua/plenary.nvim'
        }
      }, -- Autocompletion for npm packages
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
  },                         -- Code autocompletion
  'stevearc/dressing.nvim',  -- Make input windows nicer
  'smerrill/vcl-vim-plugin', -- VCL syntax support
  'imsnif/kdl.vim',          -- KDL syntax support
  'hjson/vim-hjson',         -- HJSON syntax support
}
