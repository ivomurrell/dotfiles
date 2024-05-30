return {
	'folke/lazy.nvim',                                  -- Package manager
	{ 'lewis6991/impatient.nvim',     enabled = false }, -- Implements caching to speed up startup
	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
		init = function()
			vim.g.startuptime_tries = 10
		end,
	},
	{
		'jose-elias-alvarez/null-ls.nvim',
		enabled = false,
		dependencies = { 'nvim-lua/plenary.nvim' },
	}, -- add LSP support for non-LSP tools
	{
		'stevearc/conform.nvim',
		event = 'BufWritePre',
		cmd = { 'ConformInfo', 'FormatEnable', 'FormatDisable' },
		opts = function()
			local config = {
				formatters_by_ft = {},
				format_after_save = function(bufnr)
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					return {
						lsp_fallback = true,
					}
				end,
				formatters = {
					deno_fmt = {
						cwd = require("conform.util").root_file({ "deno.json", "deno.jsonc" }),
						require_cwd = true
					}
				}
			}
			local languages = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'css', 'scss', 'less',
				'html', 'json', 'jsonc', 'yaml', 'markdown', 'markdown.mdx', 'graphql', 'handlebars' }
			local deno_langs = { 'javascript', 'javascriptreact', 'json', 'jsonc', 'markdown', 'typescript', 'typescriptreact' }
			local function supportedByDeno(ft)
				for _, denolang in pairs(deno_langs) do
					if denolang == ft then
						return true
					end
				end
			end
			for _, lang in pairs(languages) do
				config.formatters_by_ft[lang] = supportedByDeno(lang) and
						{ { 'deno_fmt', 'prettierd', 'prettier' } } or
						{ { 'prettierd', 'prettier' } }
			end
			return config
		end,
		config = function(_, opts)
			require('conform').setup(opts)
			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})
			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})
		end
	}, -- define non-LSP formatters
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
			'andymass/vim-matchup'
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
	}, -- Show surrounding functions when occluded
	{
		'andymass/vim-matchup',
		enabled = false,
		event = { "BufReadPost", "BufNewFile" },
	},                      -- Improve %-jumping with treesitter integration
	'folke/tokyonight.nvim', -- Colour scheme that supports other plugins
	{
		'tpope/vim-commentary',
		enabled = false
	},                              -- Comment out lines
	'tpope/vim-sleuth',             -- Detect indentation
	'tpope/vim-unimpaired',         -- [ and ] shortcuts
	'tpope/vim-fugitive',           -- Git plugin
	'tpope/vim-rhubarb',            -- GitHub support for fugitive.vim
	'machakann/vim-highlightedyank', -- Highlight line when yanking
	'machakann/vim-sandwich',       -- Add surroundings to text objects
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
	}, -- Insert closing characters for pairs
	{ 'kyazdani42/nvim-web-devicons', lazy = true,    config = true },
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'kyazdani42/nvim-web-devicons' },
		event = "VeryLazy",
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
					vim.schedule(function() require('gitsigns').next_hunk() end)
					return '<Ignore>'
				end, { buffer = bufnr, expr = true })
				vim.keymap.set('n', '[c', function()
					if vim.wo.diff then return '[c' end
					vim.schedule(function() require('gitsigns').prev_hunk() end)
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
	}, -- Graphical file explorer
	{
		'akinsho/bufferline.nvim',
		version = "*",
		dependencies = { 'kyazdani42/nvim-web-devicons' },
		event = "VeryLazy",
		config = true,
		enabled = false
	},                         -- Tabs in a buffer line
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
	},                                                                                       -- List diagnositic errors
	{ 'mfussenegger/nvim-dap', enabled = false },                                            -- Debugging tooling
	{ 'rcarriga/nvim-dap-ui',  enabled = false, dependencies = { 'mfussenegger/nvim-dap' } }, -- UI for debugging
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
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" } })
				end
			},
			{ '<space>g', '<cmd>Telescope live_grep<cr>' },
			{ '<space>*', '<cmd>Telescope grep_string<cr>' },
			{ '<space>b', '<cmd>Telescope buffers<cr>' },
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
					}
				}
			})
		end
	}, -- Fuzzy search for various lists such as project files
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
	},                                        -- Format source files
	'stevearc/dressing.nvim',                 -- Make input windows nicer
	{ 'smerrill/vcl-vim-plugin', ft = 'vcl' }, -- VCL syntax support
}
