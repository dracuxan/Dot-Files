local vim = vim

return {
	"williamboman/mason.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				local telescope = require("telescope.builtin")
				map("gd", telescope.lsp_definitions, "[G]oto [D]efinition")
				map("gr", telescope.lsp_references, "[G]oto [R]eferences")
				map("gI", telescope.lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", telescope.lsp_type_definitions, "Type [D]efinition")
				map("<leader>ds", telescope.lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", telescope.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end
			end,
		})

		vim.diagnostic.config({
			update_in_insert = false,
			virtual_text = true,
			signs = true,
			underline = true,
		})

		local servers = {
			lua_ls = {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						runtime = { version = "LuaJIT" },
						diagnostics = { disable = { "missing-fields" }, globals = { "vim" } },
						format = {
							enable = false,
						},
					},
				},
			},
			gopls = {
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_markers = { "go.work", "go.mod", ".git" },
			},
			rust_analyzer = {
				cmd = { "rust-analyzer" },
				filetypes = { "rust" },
				root_markers = { "Cargo.toml", "rust-project.json", ".git" },
			},
			nil_ls = {
				cmd = { "nil" },
				filetypes = { "nix" },
				root_markers = { "flake.nix", "shell.nix", ".git" },
			},
			bashls = {
				cmd = { "bash-language-server", "start" },
				filetypes = { "bash", "sh" },
				root_markers = { ".git" },
			},
			ols = {
				cmd = { "ols" },
				filetypes = { "odin" },
				root_markers = { "ols.json", "odin.json", ".git" },
			},
			ocamllsp = {
				cmd = { "opam", "exec", "--", "ocamllsp" },
				filetypes = { "ocaml", "menhir", "ocamlinterface", "ocamllex", "reason", "dune" },
				root_dir = function(bufnr, on_dir)
					local file = vim.api.nvim_buf_get_name(bufnr)
					local root =
						vim.fs.root(file, { "dune-project", "dune-workspace", "esy.json", "package.json", ".git" })

					if root then
						on_dir(root)
						return
					end

					for dir in vim.fs.parents(file) do
						local opam_files = vim.fn.glob(dir .. "/*.opam", false, true)
						if #opam_files > 0 then
							on_dir(dir)
							return
						end
					end

					on_dir(vim.fs.dirname(file))
				end,
			},
			elixirls = {
				cmd = { "elixir-ls" },
				filetypes = { "elixir", "eelixir", "heex", "surface" },
				root_markers = { "mix.exs", ".git" },
				settings = {
					elixirLS = {
						dialyzerEnabled = false,
						fetchDeps = false,
					},
				},
			},
		}

		require("mason").setup()

		require("mason-tool-installer").setup({
			ensure_installed = {
				"lua-language-server",
				-- "html-lsp",
				-- "css-lsp",
				"gopls",
				"rust-analyzer",
				"nil",
				"bash-language-server",
				"ols",
				"elixir-ls",
				"stylua",
				"shfmt",
				"checkmake",
				"prettier",
				"nixfmt",
				"goimports",
			},
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
		vim.lsp.config("*", { capabilities = capabilities })

		for server_name, server in pairs(servers) do
			vim.lsp.config(server_name, server)
			vim.lsp.enable(server_name)
		end
	end,
}
