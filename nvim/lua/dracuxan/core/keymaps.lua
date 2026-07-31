local vk = vim.keymap.set

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Defaults
local opts = { noremap = true, silent = true }

-- Insert
vk("i", "<C-b>", "<C-o>^", opts)
vk("i", "<C-e>", "<C-o>$", opts)

-- Normal/Visual
vk({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Save
vk("n", "<C-s>", "<cmd> w <CR>", opts)
vk("i", "<C-s>", "<Esc><cmd> w <CR>", opts)
vk("n", "<leader>s", "<cmd> noautocmd w <CR>", opts)
vk("n", "<leader>a", "<cmd> AutoSession search <CR>", opts)

-- Edit
vk("n", "x", '"_x', opts)

-- Resize
vk("n", "<Up>", ":resize -2<CR>", opts)
vk("n", "<Down>", ":resize +2<CR>", opts)
vk("n", "<Left>", ":vertical resize -2<CR>", opts)
vk("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Buffers
vk("n", "<Tab>", ":bnext<CR>", opts)
vk("n", "<S-Tab>", ":bprevious<CR>", opts)
vk("n", "<leader>x", ":bdelete!<CR>", opts)
vk("n", "<leader>x", function()
	local bufnr = vim.api.nvim_get_current_buf() -- Get the current buffer number
	local buffers = vim.fn.getbufinfo({ buflisted = 1 }) -- Get list of open buffers

	if #buffers > 1 then
		vim.cmd("bnext") -- Switch to the next buffer
	else
		vim.cmd("enew") -- Open a new empty buffer if it's the last one
	end

	vim.cmd("bdelete! " .. bufnr) -- Delete the previous buffer
end, opts)

-- Windows
vk("n", "<C-k>", ":wincmd k<CR>", opts)
vk("n", "<C-j>", ":wincmd j<CR>", opts)
vk("n", "<C-h>", ":wincmd h<CR>", opts)
vk("n", "<C-l>", ":wincmd l<CR>", opts)

-- Visual
vk("v", "<", "<gv", opts)
vk("v", ">", ">gv", opts)
vk("v", "p", '"_dP', opts)

-- Diagnostics
vk("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vk("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Lazy
vk("n", "<leader>l", "<cmd>Lazy<CR>", opts)

-- Snacks
vk("n", "<M-\\>", function()
	require("snacks").explorer()
end, { desc = "Toggle Snacks Explorer" })

-- Quit
vk("n", "<C-q>", "<cmd> qa <CR>", opts)
vk("i", "<C-q>", "<cmd> qa <CR>", opts)
vk("n", "qq", "<cmd> q <CR>", opts)

-- Telescope
vk(
	"n",
	"<leader>ft",
	"<cmd> TodoTelescope <CR>",
	{ desc = "[F]ind [T]odos using telescope", noremap = true, silent = true }
)

-- File reload
vk("n", "<leader>fr", ":checktime<CR>", { desc = "Check external file changes" })
vk("n", "<leader>fr!", ":edit!<CR>", { desc = "Force reload file" })

-- Terminal
vk("t", "<C-h>", [[<C-\><C-N><C-w>h]])
vk("t", "<C-j>", [[<C-\><C-N><C-w>j]])
vk("t", "<C-k>", [[<C-\><C-N><C-w>k]])
vk("t", "<C-l>", [[<C-\><C-N><C-w>l]])
