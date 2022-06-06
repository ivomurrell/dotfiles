require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Package manager
  use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client
  use 'tpope/vim-commentary' -- Comment out lines
  use 'machakann/vim-highlightedyank' -- Highlight line when yanking
  use 'machakann/vim-sandwich' -- Add surroundings to text objects
  use 'justinmk/vim-sneak' -- Jump to location with two characters
end)
