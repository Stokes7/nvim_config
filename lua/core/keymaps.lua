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

----------------------------
-- File Operations
-----------------------------
-- Save file
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", opts)

-- Save file without auto-formatting
vim.keymap.set("n", "<leader>fn", "<cmd>noautocmd w<CR>", { desc = "Save without autocommands" })

-- Quit file
vim.keymap.set("n", "<C-q>", "<cmd>q<CR>", opts)

-----------------------------
-- Editing Shortcuts
-----------------------------
vim.keymap.set("n", "<leader>xx", '"_x', { desc = "Delete char without yank" })
vim.keymap.set("n", "<leader>xX", '"_dd', { desc = "Delete line without yank" })

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
vim.keymap.set("n", "<leader>ud", function()
	local config = vim.diagnostic.config()
	if config.virtual_text or config.signs then
		vim.diagnostic.config({
			virtual_text = false,
			signs = false,
			underline = false,
		})
		vim.notify("Diagnostics OFF")
	else
		vim.diagnostic.config({
			virtual_text = { source = "if_many", spacing = 2 },
			signs = true,
			underline = { severity = vim.diagnostic.severity.ERROR },
		})
		vim.notify("Diagnostics ON")
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

-- vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
-- vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
-- vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
-- vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-----------------------------
-- Buffer Navigation
-----------------------------
vim.keymap.set("n", "H", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "L", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Close buffer safely
vim.keymap.set("n", "<leader>bd", "<cmd>Bdelete<CR>", { noremap = true, silent = true, desc = "Delete buffer" })

-- New empty buffer
vim.keymap.set("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New buffer" })

-----------------------------
-- Window Management
-----------------------------
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Equalize splits" })
vim.keymap.set("n", "<leader>wc", "<cmd>close<CR>", { desc = "Close window" })

-----------------------------
-- Tab Management
-----------------------------
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", opts)
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", opts)
vim.keymap.set("n", "<leader>tP", ":tabp<CR>", opts)
vim.keymap.set("n", "<leader>tN", ":tabn<CR>", opts)

-----------------------------
-- Toggle Line Wrapping
-----------------------------
vim.keymap.set("n", "<leader>uw", function()
	vim.wo.wrap = not vim.wo.wrap
	vim.notify("Wrap " .. (vim.wo.wrap and "ON" or "OFF"))
end, { desc = "Toggle line wrap" })

-- Smart movement when wrap is enabled
vim.keymap.set("n", "j", function()
	return vim.v.count == 0 and vim.wo.wrap and "gj" or "j"
end, { expr = true, silent = true })

vim.keymap.set("n", "k", function()
	return vim.v.count == 0 and vim.wo.wrap and "gk" or "k"
end, { expr = true, silent = true })

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

vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Open diagnostic tooltip" })

vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-----------------------------
-- Spellcheck Toggle (English only)
-----------------------------
local allowed = {
	markdown = true,
	text = true,
	gitcommit = true,
	tex = true,
	latex = true,
	typst = true,
}

vim.keymap.set("n", "<leader>us", function()
	local ft = vim.bo.filetype
	if not allowed[ft] then
		vim.notify("Spellcheck not enabled for filetype: " .. (ft or ""))
		return
	end

	if vim.wo.spell then
		vim.wo.spell = false
		vim.notify("Spellcheck OFF")
	else
		vim.opt_local.spell = true
		vim.opt_local.spelllang = { "en_us" }
		vim.notify("Spellcheck ON (en_us)")
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
			"<leader>mp",
			"<cmd>TypstPreviewToggle<CR>",
			{ buffer = buf, desc = "Toggle Typst Preview" }
		)
		vim.keymap.set("n", "<leader>ms", "<cmd>TypstPreviewStop<CR>", { buffer = buf, desc = "Stop Typst Preview" })
		vim.keymap.set(
			"n",
			"<leader>mu",
			"<cmd>TypstPreviewUpdate<CR>",
			{ buffer = buf, desc = "Update Typst binaries" }
		)
		vim.keymap.set(
			"n",
			"<leader>mf",
			"<cmd>TypstPreviewFollowCursorToggle<CR>",
			{ buffer = buf, desc = "Toggle follow cursor" }
		)
		vim.keymap.set(
			"n",
			"<leader>my",
			"<cmd>TypstPreviewSyncCursor<CR>",
			{ buffer = buf, desc = "Sync cursor with preview" }
		)
	end,
})

-----------------------------
--- Leetcode
-----------------------------
vim.api.nvim_create_user_command("LeetMMix", function()
	vim.cmd("Leet list")
	vim.defer_fn(function()
		vim.fn.feedkeys("medium array matrix simulation hash unsolved", "t")
	end, 300)
end, {})
-----------------------------
-- VimTeX Keymaps (LaTeX only)
-----------------------------
-- LeetCode keymaps
vim.keymap.set("n", "<leader>cl", ":Leet<CR>", { desc = "LeetCode menu" })
vim.keymap.set("n", "<leader>ct", ":Leet test<CR>", { desc = "LeetCode test" })
vim.keymap.set("n", "<leader>cr", ":Leet run<CR>", { desc = "LeetCode run examples" })
vim.keymap.set("n", "<leader>cs", ":Leet submit<CR>", { desc = "LeetCode submit" })
