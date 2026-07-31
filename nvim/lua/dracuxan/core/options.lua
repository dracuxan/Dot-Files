local vim = vim

-- UI
vim.wo.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 2
vim.o.cursorline = false
vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true
vim.wo.signcolumn = "yes"
vim.o.showmode = false
vim.opt.termguicolors = true
vim.o.showtabline = 2
vim.o.pumheight = 10
vim.o.conceallevel = 0
vim.o.cmdheight = 1
vim.opt.fillchars = { eob = " " }

-- Behavior
-- vim.o.mouse = ""
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false
vim.o.whichwrap = "bs<>[]hl"
vim.o.scrolloff = 0
vim.o.sidescrolloff = 8
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.equalalways = false
vim.o.backspace = "indent,eol,start"

-- Indentation
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

-- Files and undo
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = true
vim.o.fileencoding = "utf-8"

-- Completion and messaging
vim.o.completeopt = "menuone,noselect"
vim.opt.shortmess:append("c")
vim.opt.iskeyword:append("-")
vim.opt.formatoptions:remove({ "c", "r", "o" })

-- Timing
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.updatetime = 1000

-- Clipboard
vim.o.clipboard = "unnamedplus"
vim.opt.clipboard = "unnamedplus"

-- Folding
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldlevel = 99
vim.o.showtabline = 0
vim.o.tabline = ""

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local set_hl = vim.api.nvim_set_hl
		set_hl(0, "TabLine", { bg = "none" })
		set_hl(0, "TabLineSel", { bg = "none", bold = true })
		set_hl(0, "TabLineFill", { bg = "none" })
		set_hl(0, "LineNr", { bg = "none" })
		set_hl(0, "CursorLineNr", { bg = "none" })
		set_hl(0, "SignColumn", { bg = "none" })
		set_hl(0, "StatusLine", { bg = "none" })
		set_hl(0, "StatusLineNC", { bg = "none" })
		set_hl(0, "NormalFloat", { bg = "none" })
		set_hl(0, "FloatBorder", { bg = "none", fg = "none" })
		set_hl(0, "OilNormal", { bg = "none" })
		set_hl(0, "OilFloat", { bg = "none" })
	end,
})
