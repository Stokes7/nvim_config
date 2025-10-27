-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set("n", "<C-s>", "<cmd> w <CR>", opts)

-- save file without auto-formatting
vim.keymap.set("n", "<leader>sn", "<cmd>noautocmd w <CR>", opts)

-- quit file
vim.keymap.set("n", "<C-q>", "<cmd> q <CR>", opts)

-- lowercase x → delete character without yanking
vim.keymap.set("n", "x", '"_x', opts)

-- uppercase X (Shift+x) → delete whole line without yanking
vim.keymap.set("n", "X", '"_dd', opts)

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- Toggle diagnostics ON/OFF
vim.keymap.set("n", "<leader>td", function()
	local config = vim.diagnostic.config()
	if config.virtual_text or config.signs then
		vim.diagnostic.config({
			virtual_text = false,
			signs = false,
			underline = false,
		})
		print("Diagnostics OFF")
	else
		vim.diagnostic.config({
			virtual_text = { source = "if_many", spacing = 2 },
			signs = true,
			underline = { severity = vim.diagnostic.severity.ERROR },
		})
		print("Diagnostics ON")
	end
end, { desc = "Toggle diagnostics" })

-- Diff con el último commit (HEAD)
vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>", { noremap = true, silent = true, desc = "Diff vs HEAD" })

-- Diff con el index (lo que está staged)
vim.keymap.set("n", "<leader>gi", ":Gdiffsplit!<CR>", { noremap = true, silent = true, desc = "Diff vs INDEX" })

-- Diff con la rama remota principal
vim.keymap.set(
	"n",
	"<leader>gr",
	":Gdiffsplit origin/main:%<CR>",
	{ noremap = true, silent = true, desc = "Diff vs origin/main" }
)

-- Resize with arrows
vim.keymap.set("n", "<Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
--vim.keymap.set("n", "<leader>x", ":bdelete!<CR>", opts) -- close buffer
vim.keymap.set("n", "<leader>x", "<cmd>bn|bd #<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>b", "<cmd> enew <CR>", opts) -- new buffer

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s", opts) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
vim.keymap.set("n", "<leader>xs", ":close<CR>", opts) -- close current split window

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-- Tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", opts) --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", opts) --  go to previous tab

-- Toggle line wrapping

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>lw", function()
	vim.opt.wrap = not vim.opt.wrap:get()

	if vim.opt.wrap:get() then
		-- Normal mode: move by visual lines
		vim.keymap.set("n", "j", "gj", opts)
		vim.keymap.set("n", "k", "gk", opts)

		-- Insert mode: arrow keys move by visual lines
		vim.keymap.set("i", "<Down>", "<C-o>gj", opts)
		vim.keymap.set("i", "<Up>", "<C-o>gk", opts)

		print("Wrap ON - visual line movement active")
	else
		-- Normal mode: restore default movement
		vim.keymap.set("n", "j", "j", opts)
		vim.keymap.set("n", "k", "k", opts)

		-- Insert mode: restore default arrow keys
		vim.keymap.set("i", "<Down>", "<Down>", opts)
		vim.keymap.set("i", "<Up>", "<Up>", opts)

		print("Wrap OFF - normal movement active")
	end
end, opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic message" })

vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic message" })

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Toggle English spellcheck with <leader>sc for selected filetypes
local allowed = { markdown = true, text = true, gitcommit = true, latex = true, typst = true }

-- Active or desactivate the spellcheck
vim.keymap.set("n", "<leader>sc", function()
	local ft = vim.bo.filetype
	if not allowed[ft] then
		print("Spellcheck not configured for filetype: " .. (ft or ""))
		return
	end

	if vim.wo.spell then
		vim.wo.spell = false
		print("Spellcheck OFF")
	else
		vim.opt_local.spell = true
		vim.opt_local.spelllang = { "en_us" }
		print("Spellcheck ON (en_us)")
	end
end, { desc = "Toggle English spellcheck for selected filetypes" })

-- Typst-only keymaps
vim.api.nvim_create_autocmd("FileType", {
	pattern = "typst",
	callback = function(args)
		local buf = args.buf
		local opts = { noremap = true, silent = true, buffer = buf }

		vim.keymap.set("n", "<leader>tp", "<cmd>TypstPreviewToggle<CR>", { desc = "Toggle Typst Preview" })
		vim.keymap.set("n", "<leader>ts", "<cmd>TypstPreviewStop<CR>", { desc = "Stop Typst Preview" })
		vim.keymap.set("n", "<leader>tu", "<cmd>TypstPreviewUpdate<CR>", { desc = "Update Typst Preview binaries" })
		vim.keymap.set("n", "<leader>tf", "<cmd>TypstPreviewFollowCursorToggle<CR>", { desc = "Toggle follow cursor" })
		vim.keymap.set("n", "<leader>ty", "<cmd>TypstPreviewSyncCursor<CR>", { desc = "Sync cursor with preview" })
	end,
})

--vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
--	pattern = "*.typ",
--	callback = function()
--		vim.cmd("silent! write")
--	end,
--})

-- Go the first and final part of a line
vim.keymap.set("n", "1", "0", { noremap = true, silent = true })
vim.keymap.set("n", "0", "$", { noremap = true, silent = true })

-- VimTeX keymaps con <leader> (solo en buffers .tex)
local aug = vim.api.nvim_create_augroup("vimtex_leader_keymaps", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	group = aug,
	callback = function(ev)
		local function nmap(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, silent = true, noremap = true, desc = desc })
		end

		-- Básicos
		nmap("<leader>ll", "<cmd>VimtexCompile<CR>", "VimTeX: Compile/continously")
		nmap("<leader>lv", "<cmd>VimtexView<CR>", "VimTeX: View PDF (forward search)")
		nmap("<leader>lk", "<cmd>VimtexStop<CR>", "VimTeX: Stop COmpilation")
		nmap("<leader>lc", "<cmd>VimtexClean<CR>", "VimTeX: Clean Helpers")

		-- Optional
		nmap("<leader>le", "<cmd>VimtexErrors<CR>", "VimTeX: Errors/Quickfix")
		nmap("<leader>li", "<cmd>VimtexInfo<CR>", "VimTeX: Project Info")
		nmap("<leader>lt", "<cmd>VimtexTocToggle<CR>", "VimTeX: TOC Toggle")
		nmap("<leader>lq", "<cmd>VimtexLog<CR>", "VimTeX: Log")
	end,
})
