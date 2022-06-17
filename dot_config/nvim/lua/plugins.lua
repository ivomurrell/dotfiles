require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager
  use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { "typescript", "lua", "rust" },
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
  } -- Better/faster syntax highlighting with treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects' -- Add treesitter groups as textobjects
  use 'andymass/vim-matchup' -- Improve %-jumping with treesitter integration
  use 'folke/tokyonight.nvim' -- Colour scheme that supports other plugins
  use 'tpope/vim-commentary' -- Comment out lines
  use 'tpope/vim-sleuth' -- Detect indentation
  use 'tpope/vim-fugitive' -- Git plugin
  use 'tpope/vim-rhubarb' -- GitHub support for fugitive.vim
  use 'machakann/vim-highlightedyank' -- Highlight line when yanking
  use 'machakann/vim-sandwich' -- Add surroundings to text objects
  use 'justinmk/vim-sneak' -- Jump to location with two characters
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      local function indentation()
        local indent_type = vim.opt.expandtab:get() and 'spaces' or 'tabs'
        return indent_type .. ': ' .. vim.opt.shiftwidth:get()
      end

      require('lualine').setup {
        sections = { lualine_x = { indentation, 'filetype' } },
        extensions = { 'fugitive', 'nvim-tree' }
      }
    end
  } -- Customisable status line
  use { 'airblade/vim-gitgutter', disable = true } -- Show git diffs in sign column
  use 'lewis6991/gitsigns.nvim' -- Pretty git gutter and in-line blame
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    tag = 'nightly',
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
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('trouble').setup {}
    end
  } -- List diagnositic errors
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim', 'kyazdani42/nvim-web-devicons' }
  } -- Fuzzy search for various lists such as project files
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  } -- Use fzf for searching with telescope
  use {
    'ahmedkhalf/project.nvim',
    disable = true,
    config = function()
      require('project_nvim').setup {}
    end
  } -- Changes CWD to the project root
  use {
    'TimUntersberger/neogit',
    disable = true,
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('neogit').setup {}
    end
  } -- Magit clone for Neovim
  use {
    'mhartington/formatter.nvim',
    config = function()
      require('formatter').setup {
        filetype = {
          typescript = {
            require('formatter.filetypes.typescript').prettier
          }
        }
      }
    end
  } -- Format source files
  use {
    'ms-jpq/coq_nvim',
    setup = function()
      vim.g.coq_settings = { auto_start = 'shut-up' }
    end
  } -- Code autocompletion
  use 'ms-jpq/coq.artifacts' -- Autocompletion snippets
  use {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup {
        stop_eof = false,
        easing = 'cubic'
      }
    end
  } -- Smooooth scrolling
end)
