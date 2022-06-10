require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager
  use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client
  use 'folke/tokyonight.nvim' -- Colour scheme that supports other plugins
  use 'tpope/vim-commentary' -- Comment out lines
  use 'tpope/vim-sleuth' -- Detect indentation
  use 'tpope/vim-fugitive' -- Git plugin
  use 'tpope/vim-rhubarb' -- GitHub support for fugitive.vim
  use 'machakann/vim-highlightedyank' -- Highlight line when yanking
  use 'machakann/vim-sandwich' -- Add surroundings to text objects
  use 'justinmk/vim-sneak' -- Jump to location with two characters
  use { 'airblade/vim-gitgutter', disable = true } -- Show git diffs in sign column
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text_pos = 'right_align',
          delay = 400
        }
      }
    end
  } -- Pretty git gutter and in-line blame
  use 'kyazdani42/nvim-web-devicons' -- File icons in search views
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
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
