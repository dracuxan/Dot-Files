-- Set up the Lazy plugin manager
local vim = vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

local custom_plugins = {
	require("dracuxan.plugins.telescope"),
	require("dracuxan.plugins.misic"),
	require("dracuxan.plugins.lsp"),
	require("dracuxan.plugins.langages"),
	require("dracuxan.plugins.textobjects"),

	{
		"zenbones-theme/zenbones.nvim",
		-- Optionally install Lush. Allows for more configuration or extending the colorscheme
		-- If you don't want to install lush, make sure to set g:zenbones_compat = 1
		-- In Vim, compat mode is turned on as Lush only works in Neovim.
		dependencies = "rktjmp/lush.nvim",
		lazy = false,
		priority = 1000,
		-- you can set set configuration options here
		-- config = function()
		--     vim.g.zenbones_darken_comments = 45
		--     vim.cmd.colorscheme('zenbones')
		-- end
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	{
		"xero/evangelion.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			overrides = {
				keyword = { fg = "#00ff00", bg = "#222222", undercurl = true },
				["@boolean"] = { link = "Special" },
			},
		},
	},

	{
		"pyratebeard/goblinmode.nvim",
		name = "goblinmode.nvim",
		lazy = false,
		dev = { true },
		priority = 1000,
		config = function() end,
		dependencies = { "rktjmp/lush.nvim" },
	},

	{
		"tiagovla/scope.nvim",
		config = function()
			require("scope").setup({})
		end,
	},

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			explorer = {
				enabled = true,
			},
			picker = {
				sources = {
					explorer = {
						layout = {
							preset = "sidebar",
							preview = false,
							layout = {
								position = "right",
								width = 30,
							},
						},
					},
				},
			},
		},
	},

	{
		"nyoom-engineering/oxocarbon.nvim",
	},

	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
	},

	{
		"folke/noice.nvim",
		config = function()
			require("noice").setup({
				-- add any options here
				lsp = {
					documentation = {
						opts = {
							size = {
								max_width = 80,
								max_height = 20,
							},
						},
					},
				},
				routes = {
					{
						filter = {
							event = "msg_show",
							any = {
								{ find = "%d+L, %d+B" },
								{ find = "; after #%d+" },
								{ find = "; before #%d+" },
								{ find = "%d fewer lines" },
								{ find = "%d more lines" },
							},
						},
						opts = { skip = true },
					},
				},
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					lsp_doc_border = true, -- add a border to hover docs and signature help
				},
			})
		end,
		dependencies = { "MunifTanjim/nui.nvim" },
	},

	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("dracuxan.plugins.toggleterm")
		end,
		lazy = false,
	},

	{
		"datsfilipe/vesper.nvim",
		version = false,
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("dracuxan.plugins.vesper")
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			local hooks = require("ibl.hooks")

			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				-- normal indent lines (purple)
				vim.api.nvim_set_hl(0, "IndentWhite", { fg = "#ffffff" })

				-- active scope (when cursor inside function)
				vim.api.nvim_set_hl(0, "ScopeGray", { fg = "#808080" })
			end)

			require("ibl").setup({
				indent = {
					highlight = { "ScopeGray" },
				},
				scope = {
					enabled = true,
					highlight = { "IndentWhite" },
					show_start = true,
					show_end = true,
				},
			})
		end,
	},

	{
		"rmagatti/auto-session",
		config = function()
			local height = math.floor(vim.o.lines * 0.45)
			local width = 70

			require("auto-session").setup({
				session_lens = {
					picker_opts = {
						height = height,
						width = width,
						layout_strategy = "center",
						layout_config = {
							anchor = "C",
						},
						-- 	border = "rounded",
					},
				},
				log_level = "error",
				auto_session_suppress_dirs = { "~/", "~/Downloads" },
			})
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		disabled_filetypes = { "alpha" },
		config = function()
			require("dracuxan.plugins.lualine")
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			signs_staged = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	{
		"numToStr/Comment.nvim",
		opts = {},
		config = function()
			local opts = { noremap = true, silent = true }
			vim.keymap.set("i", "<C-c>", require("Comment.api").toggle.linewise.current, opts)
			vim.keymap.set("n", "<C-c>", require("Comment.api").toggle.linewise.current, opts)
			vim.keymap.set(
				"v",
				"<C-c>",
				"<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
				opts
			)
		end,
	},
}

require("lazy").setup(custom_plugins)
