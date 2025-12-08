------------------------------
-- Leader must be defined FIRST
-----------------------------
-- lazy.nvim requires <leader> to be set before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

----------------------------
-- Leader Key Behavior
-----------------------------
-- Disable <Space> default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-----------------------------
-- Default Mapping Options
-----------------------------
local opts = { noremap = true, silent = true }

-----------------------------
-- File Operations
-----------------------------
-- Save file
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", opts)

-- Save file without auto-formatting
vim.keymap.set("n", "<leader>sn", "<cmd>noautocmd w<CR>", opts)

-- Quit file
vim.keymap.set("n", "<C-q>", "<cmd>q<CR>", opts)

-----------------------------
-- Editing Shortcuts
-----------------------------
-- Delete a single character without yanking
vim.keymap.set("n", "x", '"_x', opts)

-- Delete whole line without yanking
vim.keymap.set("n", "X", '"_dd', opts)

-----------------------------
-- Navigation Enhancements
-----------------------------
-- Scroll and center cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Find next/previous and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-----------------------------
-- Diagnostics Toggle
-----------------------------
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

-----------------------------
-- Git Diff Shortcuts (Fugitive)
-----------------------------
vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>", { noremap = true, silent = true, desc = "Diff vs HEAD" })

vim.keymap.set("n", "<leader>gi", ":Gdiffsplit!<CR>", { noremap = true, silent = true, desc = "Diff vs INDEX" })

vim.keymap.set(
	"n",
	"<leader>gr",
	":Gdiffsplit origin/main:%<CR>",
	{ noremap = true, silent = true, desc = "Diff vs origin/main" }
)

-----------------------------
-- Smart-Splits Navigation
-----------------------------
-- local ok, smart_splits = pcall(require, "smart-splits")
-- if ok then
-- 	-- Move between splits
-- 	vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left)
-- 	vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down)
-- 	vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up)
-- 	vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right)
--
-- 	-- Resize splits
-- 	vim.keymap.set("n", "<A-h>", smart_splits.resize_left)
-- 	vim.keymap.set("n", "<A-j>", smart_splits.resize_down)
-- 	vim.keymap.set("n", "<A-k>", smart_splits.resize_up)
-- 	vim.keymap.set("n", "<A-l>", smart_splits.resize_right)
-- end

-----------------------------
-- Normal Splits Navigation
-----------------------------
vim.keymap.set("n", "<Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts)

vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-----------------------------
-- Buffer Navigation
-----------------------------
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)

-- Close buffer safely
vim.keymap.set("n", "<leader>x", "<cmd>bn|bd #<CR>", { noremap = true, silent = true })

-- New empty buffer
vim.keymap.set("n", "<leader>b", "<cmd>enew<CR>", opts)

-----------------------------
-- Window Management
-----------------------------
vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- Vertical split
vim.keymap.set("n", "<leader>h", "<C-w>s", opts) -- Horizontal split
vim.keymap.set("n", "<leader>se", "<C-w>=", opts) -- Equalize splits
vim.keymap.set("n", "<leader>xs", ":close<CR>", opts)

-----------------------------
-- Tab Management
-----------------------------
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", opts)
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", opts)
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", opts)
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", opts)

-----------------------------
-- Toggle Line Wrapping
-----------------------------
vim.keymap.set("n", "<leader>lw", function()
	vim.opt.wrap = not vim.opt.wrap:get()

	if vim.opt.wrap:get() then
		-- Move by visual lines in Normal mode
		vim.keymap.set("n", "j", "gj", opts)
		vim.keymap.set("n", "k", "gk", opts)

		-- Move by visual lines in Insert mode (arrows)
		vim.keymap.set("i", "<Down>", "<C-o>gj", opts)
		vim.keymap.set("i", "<Up>", "<C-o>gk", opts)

		print("Wrap ON - visual line movement active")
	else
		-- Restore default movement
		vim.keymap.set("n", "j", "j", opts)
		vim.keymap.set("n", "k", "k", opts)

		-- Restore arrow keys
		vim.keymap.set("i", "<Down>", "<Down>", opts)
		vim.keymap.set("i", "<Up>", "<Up>", opts)

		print("Wrap OFF - normal movement active")
	end
end, opts)

-----------------------------
-- Visual Mode Improvements
-----------------------------
-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Keep last yanked value when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-----------------------------
-- Diagnostic Navigation
-----------------------------
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })

vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open diagnostic tooltip" })

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-----------------------------
-- Spellcheck Toggle (English only)
-----------------------------
local allowed = {
	markdown = true,
	text = true,
	gitcommit = true,
	latex = true,
	typst = true,
}

vim.keymap.set("n", "<leader>sc", function()
	local ft = vim.bo.filetype
	if not allowed[ft] then
		print("Spellcheck not enabled for filetype: " .. (ft or ""))
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
end, { desc = "Toggle English spellcheck" })

-----------------------------
-- Typst Filetype Keymaps
-----------------------------
vim.api.nvim_create_autocmd("FileType", {
	pattern = "typst",
	callback = function(args)
		local buf = args.buf

		-- Typst preview commands
		vim.keymap.set(
			"n",
			"<leader>tp",
			"<cmd>TypstPreviewToggle<CR>",
			{ buffer = buf, desc = "Toggle Typst Preview" }
		)
		vim.keymap.set("n", "<leader>ts", "<cmd>TypstPreviewStop<CR>", { buffer = buf, desc = "Stop Typst Preview" })
		vim.keymap.set(
			"n",
			"<leader>tu",
			"<cmd>TypstPreviewUpdate<CR>",
			{ buffer = buf, desc = "Update Typst binaries" }
		)
		vim.keymap.set(
			"n",
			"<leader>tf",
			"<cmd>TypstPreviewFollowCursorToggle<CR>",
			{ buffer = buf, desc = "Toggle follow cursor" }
		)
		vim.keymap.set(
			"n",
			"<leader>ty",
			"<cmd>TypstPreviewSyncCursor<CR>",
			{ buffer = buf, desc = "Sync cursor with preview" }
		)
	end,
})

-----------------------------
-- VimTeX Keymaps (LaTeX only)
-----------------------------
local aug = vim.api.nvim_create_augroup("vimtex_leader_keymaps", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	group = aug,
	callback = function(ev)
		local function nmap(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, {
				buffer = ev.buf,
				silent = true,
				noremap = true,
				desc = desc,
			})
		end

		-- Basic VimTeX commands
		nmap("<leader>ll", "<cmd>VimtexCompile<CR>", "Compile / continuous mode")
		nmap("<leader>lv", "<cmd>VimtexView<CR>", "Open PDF viewer")
		nmap("<leader>lk", "<cmd>VimtexStop<CR>", "Stop compilation")
		nmap("<leader>lc", "<cmd>VimtexClean<CR>", "Clean auxiliary files")

		-- Optional extras
		nmap("<leader>le", "<cmd>VimtexErrors<CR>", "Show errors")
		nmap("<leader>li", "<cmd>VimtexInfo<CR>", "Project info")
		nmap("<leader>lt", "<cmd>VimtexTocToggle<CR>", "Toggle TOC")
		nmap("<leader>lq", "<cmd>VimtexLog<CR>", "Show compilation log")
	end,
})
