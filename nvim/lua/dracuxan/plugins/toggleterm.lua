local vim = vim
local float = "float"
local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

toggleterm.setup({
	size = function(term)
		if term.direction == "horizontal" then
			return math.max(8, math.floor(vim.api.nvim_win_get_height(0) * 0.4))
		else
			return math.max(30, math.floor(vim.api.nvim_win_get_width(0) * 0.4))
		end
	end,
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = false,
	direction = float,
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

function _G.set_terminal_keymaps()
	local opts = { noremap = true }
	vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
local Terminal = require("toggleterm.terminal").Terminal

local pane_terms = {}

local function pane_term_size()
	return math.max(15, math.floor(vim.api.nvim_win_get_height(0) * 0.65))
end

local function toggle_pane_term(key, cmd)
	local bufnr = pane_terms[key]

	if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
		local wins = vim.fn.win_findbuf(bufnr)
		if #wins > 0 then
			vim.api.nvim_win_close(wins[1], true)
			return
		end

		vim.cmd("split")
		vim.cmd("resize " .. pane_term_size())
		vim.api.nvim_win_set_buf(0, bufnr)
		vim.cmd("startinsert")
		return
	end

	vim.cmd("split")
	vim.cmd("resize " .. pane_term_size())

	bufnr = vim.api.nvim_create_buf(false, true)
	pane_terms[key] = bufnr
	vim.api.nvim_win_set_buf(0, bufnr)
	vim.fn.termopen(cmd or vim.o.shell)
	vim.cmd("startinsert")
end

function _RUN_SCRIPT()
	local buffname = vim.api.nvim_buf_get_name(0)
	local filepath = vim.fn.fnamemodify(buffname, ":p")
	toggle_pane_term("run", "run " .. filepath)
end

function _RUN_TEST()
	local buffname = vim.api.nvim_buf_get_name(0)
	local filepath = vim.fn.fnamemodify(buffname, ":p")
	toggle_pane_term("test", "run " .. filepath .. " --test")
end

function _RUN_REPL()
	local buffname = vim.api.nvim_buf_get_name(0)
	local filepath = vim.fn.fnamemodify(buffname, ":p")
	local script_test = Terminal:new({
		cmd = "run " .. filepath .. " --repl",
		direction = float,
		persist_size = false,
		hidden = true,
		close_on_exit = false,
	})
	script_test:toggle()
end

function _RUN_MIX()
	local buffname = vim.api.nvim_buf_get_name(0)
	local filepath = vim.fn.fnamemodify(buffname, ":p")
	toggle_pane_term("mix", "run " .. filepath .. " --mix")
end

function _RUN_BUILD()
	local buffname = vim.api.nvim_buf_get_name(0)
	local filepath = vim.fn.fnamemodify(buffname, ":p")
	toggle_pane_term("build", "run " .. filepath .. " --build")
end

function _SEND_BIN()
	local buffname = vim.api.nvim_buf_get_name(0)
	local filepath = vim.fn.fnamemodify(buffname, ":p")
	local sendToServer = "run " .. filepath .. " --build && scp ./bin/* Igris.local:/home/igris/exps"
	toggle_pane_term("send", sendToServer)
end

function _LAZYGIT_TOGGLE()
	local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

	lazygit:toggle()
end

-- Set keymaps
vim.keymap.set("n", "<leader>r", _RUN_SCRIPT, { noremap = true, silent = true, desc = "run script" })
vim.keymap.set("n", "<leader>mt", _RUN_TEST, { noremap = true, silent = true, desc = "run test(s)" })
vim.keymap.set("n", "<leader>i", _RUN_REPL, { noremap = true, silent = true, desc = "run REPL" })
vim.keymap.set("n", "<leader>mm", _RUN_MIX, { noremap = true, silent = true, desc = "run with MIX" })
vim.keymap.set("n", "<leader>mb", _RUN_BUILD, { noremap = true, silent = true, desc = "build project" })
vim.keymap.set("n", "<leader>ms", _SEND_BIN, { noremap = true, silent = true, desc = "send binaries to server" })
vim.keymap.set("n", "<leader>ml", _LAZYGIT_TOGGLE, { noremap = true, silent = true, desc = "lazygit" })
vim.keymap.set("n", "<C-t>", function()
	toggle_pane_term("shell")
end, { noremap = true, silent = true, desc = "terminal" })
