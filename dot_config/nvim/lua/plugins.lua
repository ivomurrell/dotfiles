return {
	'folke/lazy.nvim', -- Package manager
	{
		'j-hui/fidget.nvim',
		tag = 'legacy',
		event = 'VeryLazy',
		config = true,
	}, -- show LSP loading progress
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects', -- Add treesitter groups as textobjects
		},
		lazy = true,
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup {
				ensure_installed = { "typescript", "javascript", "lua", "rust" },
				auto_install = true,
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
							["av"] = "@assignment.outer",
							["iv"] = "@assignment.inner",
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
	}, -- Better/faster syntax highlighting with treesitter
	{
		'nvim-treesitter/nvim-treesitter-context',
		dependencies = {
			'nvim-treesitter/nvim-treesitter'
		},
		event = { "BufReadPost", "BufNewFile" },
		config = true
	},                                        -- Show surrounding functions when occluded
	'folke/tokyonight.nvim',                  -- Colour scheme that supports other plugins
	'tpope/vim-sleuth',                       -- Detect indentation
	'tpope/vim-unimpaired',                   -- [ and ] shortcuts
	'tpope/vim-obsession',                    -- Automatically save session
	{ 'tpope/vim-fugitive', enabled = false }, -- Git plugin
	{ 'tpope/vim-rhubarb',  enabled = false }, -- GitHub support for fugitive.vim
	'machakann/vim-highlightedyank',          -- Highlight line when yanking
	'machakann/vim-sandwich',                 -- Add surroundings to text objects
	{
		'justinmk/vim-sneak',
		keys = {
			{ 'ss', '<Plug>Sneak_s' },
			{ 'SS', '<Plug>Sneak_S' },
			{ 'z',  '<Plug>Sneak_s', mode = { 'o', 'x' } },
			{ 'Z',  '<Plug>Sneak_S', mode = { 'o', 'x' } },
			{ 'f',  '<Plug>Sneak_f' },
			{ 'F',  '<Plug>Sneak_F' },
			{ 't',  '<Plug>Sneak_t' },
			{ 'T',  '<Plug>Sneak_T' },
		}
	}, -- Jump to location with two characters
	{
		'chrisgrieser/nvim-spider',
		keys = {
			{ "w",  "<cmd>lua require('spider').motion('w')<CR>",  mode = { "n", "o", "x" }, { desc = "Spider-w" } },
			{ "e",  "<cmd>lua require('spider').motion('e')<CR>",  mode = { "n", "o", "x" }, { desc = "Spider-e" } },
			{ "b",  "<cmd>lua require('spider').motion('b')<CR>",  mode = { "n", "o", "x" }, { desc = "Spider-b" } },
			{ "ge", "<cmd>lua require('spider').motion('ge')<CR>", mode = { "n", "o", "x" }, { desc = "Spider-ge" } },
		},
	},                 -- Respect CamelCase with word motions
	'tommcdo/vim-lion', -- Aligning text
	'romainl/vim-cool', -- Disables search highlighting once I'm done
	{
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		config = true
	},                                                             -- Insert closing characters for pairs
	{ 'kyazdani42/nvim-web-devicons', lazy = true, config = true }, -- Colourful file icons using nerdfont
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'kyazdani42/nvim-web-devicons' },
		event = "VeryLazy",
		config = function()
			local function indentation()
				local indent_type = vim.o.expandtab and 'spaces' or 'tabs'
				return indent_type .. ': ' .. vim.o.shiftwidth
			end

			require('lualine').setup {
				sections = {
					lualine_b = { { 'branch', fmt = function(display_string)
						if #display_string > 20 then
							return display_string:sub(1, 20) .. '...'
						else
							return display_string
						end
					end }, 'diff', 'diagnostics' },
					lualine_c = { { 'filename', path = 1 } },
					lualine_x = { indentation, 'filetype' },
					lualine_y = { 'ObsessionStatus', 'progress' },
				},
				extensions = { 'fugitive', 'lazy', 'nvim-tree' }
			}
		end
	}, -- Customisable status line
	{
		'lewis6991/gitsigns.nvim',
		opts = {
			current_line_blame = false,
			current_line_blame_opts = {
				virt_text_pos = 'right_align',
				delay = 400
			},
			on_attach = function(bufnr)
				vim.keymap.set('n', ']c', function()
					if vim.wo.diff then return ']c' end
					vim.schedule(function() require('gitsigns').nav_hunk("next") end)
					return '<Ignore>'
				end, { buffer = bufnr, expr = true })
				vim.keymap.set('n', '[c', function()
					if vim.wo.diff then return '[c' end
					vim.schedule(function() require('gitsigns').nav_hunk("prev") end)
					return '<Ignore>'
				end, { buffer = bufnr, expr = true })

				vim.keymap.set({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
				vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk)
				vim.keymap.set('n', '<leader>tb', require('gitsigns').toggle_current_line_blame)

				vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
			end
		}
	}, -- Pretty git gutter and in-line blame
	{
		'kyazdani42/nvim-tree.lua',
		dependencies = 'kyazdani42/nvim-web-devicons',
		keys = {
			{ '<C-n>',     '<cmd>NvimTreeToggle<cr>' },
			{ '<leader>r', '<cmd>NvimTreeRefresh<cr>' },
			{ '<leader>n', '<cmd>NvimTreeFindFile<cr>' }
		},
		opts = { actions = { open_file = { quit_on_open = true } } }
	},                         -- Graphical file explorer
	{ 'ojroques/nvim-bufdel' }, -- Don't close window when deleting buffers
	{
		'folke/trouble.nvim',
		dependencies = { 'kyazdani42/nvim-web-devicons' },
		keys = {
			{ '<leader>xx', '<cmd>TroubleToggle<cr>' },
			{ '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>' },
			{ '<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>' },
		},
		config = true
	}, -- List diagnostic errors
	{
		'nvim-telescope/telescope.nvim',
		version = '^0.1.0',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'kyazdani42/nvim-web-devicons',
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make'
			}, -- Use fzf for searching with telescope
		},
		keys = {
			{ '<space><space>',
				function()
					require('telescope.builtin').find_files({
						find_command = { "rg", "--files", "--hidden", "--no-require-git", "--glob", "!.{git,jj}/" } })
				end
			},
			{ '<space>g',
				function()
					require('telescope.builtin').live_grep({
						additional_args = { "--no-require-git" },
						glob_pattern = "!.{git,jj}/"
					})
				end
			},
			{ '<space>*',
				function()
					require('telescope.builtin').grep_string({
						additional_args = { "--no-require-git" },
						glob_pattern = "!.{git,jj}/"
					})
				end
			},
			{ '<space>b',
				function()
					require('telescope.builtin').buffers({
						ignore_current_buffer = true,
						initial_mode = 'normal',
						sort_mru = true
					})
				end
			},
			{ '<space>t', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>' },
			{ '<space>h', '<cmd>Telescope help_tags<cr>' },
		},
		config = function()
			local telescope = require('telescope')
			telescope.load_extension('fzf')
			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<Down>"] = require('telescope.actions').cycle_history_next,
							["<Up>"] = require('telescope.actions').cycle_history_prev,
						}
					},
				}
			})
		end
	}, -- Fuzzy search for various lists such as project files
	{
		'NeogitOrg/neogit',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'sindrets/diffview.nvim',
			'nvim-telescope/telescope.nvim'
		},
		cmd = 'Neogit',
		config = {
			kind = "replace",
			ignored_settings = {
				"NeogitPushPopup--force-with-lease",
				"NeogitPushPopup--force",
				"NeogitPullPopup--rebase",
				"NeogitCommitPopup--allow-empty",
				"NeogitRevertPopup--no-edit",
				"NeogitCommitPopup--no-verify"
			},
			commit_view = {
				kind = "auto"
			}
		}
	},                                        -- Magit clone for Neovim
	'stevearc/dressing.nvim',                 -- Make input windows nicer
	{ 'smerrill/vcl-vim-plugin', ft = 'vcl' }, -- VCL syntax support
}
