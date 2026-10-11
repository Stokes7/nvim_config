------------------------------
-- Leader must be defined FIRST
-----------------------------
-- lazy.nvim requires <leader> to be set before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = ","

----------------------------
-- Leader Key Behavior
-----------------------------
-- Disable <Space> default behavior in Normal and Visual modes
vim.keymap.set({ "n", "x" }, "<Space>", "<Nop>", { silent = true, desc = "which_key_ignore" })

-----------------------------
-- Default Mapping Options
-----------------------------
local opts = { noremap = true, silent = true }

----------------------------
-- File Operations
-----------------------------
-- Save file
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

-- Save file without auto-formatting
vim.keymap.set("n", "<leader>fn", "<cmd>noautocmd w<CR>", { desc = "Save without autocommands" })

-- Quit file
vim.keymap.set("n", "<C-q>", "<cmd>q<CR>", { desc = "Quit window" })

-----------------------------
-- Editing Shortcuts
-----------------------------
vim.keymap.set("n", "<leader>xx", '"_x', { desc = "Delete char without yank" })
vim.keymap.set("n", "<leader>xX", '"_dd', { desc = "Delete line without yank" })

-----------------------------
-- Navigation Enhancements
-----------------------------
-- Find next/previous and center
vim.keymap.set("n", "n", "nzzzv", { desc = "Next match (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous match (centered)" })

-- Clear search highlight
vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

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
vim.keymap.set("n", "<Up>", "<cmd>resize -2<CR>", { desc = "Shrink window height" })
vim.keymap.set("n", "<Down>", "<cmd>resize +2<CR>", { desc = "Grow window height" })
vim.keymap.set("n", "<Left>", "<cmd>vertical resize -2<CR>", { desc = "Shrink window width" })
vim.keymap.set("n", "<Right>", "<cmd>vertical resize +2<CR>", { desc = "Grow window width" })

-- vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
-- vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
-- vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
-- vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-----------------------------
-- Window Navigation (works with neo-tree)
-----------------------------
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })

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
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>tP", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>tN", "<cmd>tabnext<CR>", { desc = "Next tab" })

-----------------------------
-- Toggle Line Wrapping
-----------------------------
vim.keymap.set("n", "<leader>uw", function()
	vim.wo.wrap = not vim.wo.wrap
	vim.notify("Wrap " .. (vim.wo.wrap and "ON" or "OFF"))
end, { desc = "Toggle line wrap" })

-- Smart movement when wrap is enabled: move by visual line, not logical line.
-- With a count (3j) we keep logical lines so relativenumber jumps stay correct.
local function wrapped(visual_key, plain_key)
	return function()
		return (vim.v.count == 0 and vim.wo.wrap) and visual_key or plain_key
	end
end

for _, m in ipairs({
	{ "j", "gj" },
	{ "k", "gk" },
}) do
	vim.keymap.set({ "n", "x" }, m[1], wrapped(m[2], m[1]), { expr = true, silent = true })
end

-- Start/end of the *visual* line when wrapping
for _, m in ipairs({
	{ "0", "g0" },
	{ "^", "g^" },
	{ "$", "g$" },
}) do
	vim.keymap.set({ "n", "x" }, m[1], wrapped(m[2], m[1]), { expr = true, silent = true })
end

-- Arrow keys in insert mode also follow visual lines
vim.keymap.set("i", "<Down>", "<Cmd>normal! gj<CR>", { silent = true })
vim.keymap.set("i", "<Up>", "<Cmd>normal! gk<CR>", { silent = true })

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
			{ buffer = buf, desc = "Toggle Typst Live Preview (Browser)" }
		)
		vim.keymap.set("n", "<leader>mP", function()
			local pdf = vim.fn.expand("%:p:r") .. ".pdf"
			if vim.fn.filereadable(pdf) == 1 then
				vim.cmd("edit " .. vim.fn.fnameescape(pdf))
			else
				vim.notify("Compiled PDF not found: " .. vim.fn.fnamemodify(pdf, ":t"), vim.log.levels.WARN)
			end
		end, { buffer = buf, desc = "Open compiled PDF in Zen Browser" })
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
-- VimTeX Keymaps (LaTeX only)
-----------------------------
vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function(args)
		local buf = args.buf

		-- Compile (toggle continuous mode)
		vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<CR>", { buffer = buf, desc = "Compile (continuous)" })

		-- View PDF in Zathura (forward search)
		vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<CR>", { buffer = buf, desc = "View PDF" })

		-- Stop compilation
		vim.keymap.set("n", "<leader>lk", "<cmd>VimtexStop<CR>", { buffer = buf, desc = "Stop compiler" })

		-- Show errors/warnings
		vim.keymap.set("n", "<leader>le", "<cmd>VimtexErrors<CR>", { buffer = buf, desc = "Show errors" })

		-- Table of contents
		vim.keymap.set("n", "<leader>lt", "<cmd>VimtexTocToggle<CR>", { buffer = buf, desc = "Table of contents" })

		-- Clean auxiliary files
		vim.keymap.set("n", "<leader>lc", "<cmd>VimtexClean<CR>", { buffer = buf, desc = "Clean aux files" })

		-- Clean all (including PDF)
		vim.keymap.set("n", "<leader>lC", "<cmd>VimtexClean!<CR>", { buffer = buf, desc = "Clean all (+ PDF)" })

		-- Project info
		vim.keymap.set("n", "<leader>li", "<cmd>VimtexInfo<CR>", { buffer = buf, desc = "Project info" })

		-- Status
		vim.keymap.set("n", "<leader>ls", "<cmd>VimtexStatus<CR>", { buffer = buf, desc = "Compiler status" })
	end,
})

-----------------------------
-- CSV viewer
-----------------------------
vim.keymap.set("n", "<leader>ve", "<cmd>CsvViewEnable<CR>", { desc = "CSV: enable view" })
vim.keymap.set("n", "<leader>vd", "<cmd>CsvViewDisable<CR>", { desc = "CSV: disable view" })
vim.keymap.set("n", "<leader>vi", "<cmd>CsvViewInfo<CR>", { desc = "CSV: info" })

vim.keymap.set("n", "<leader>vv", function()
	vim.ui.input({
		prompt = "Header line (empty=auto, 0=none, number=explicit): ",
	}, function(input)
		if input == nil then
			return
		end

		input = vim.trim(input)

		if input == "" then
			vim.cmd("CsvViewEnable")
			return
		end

		if input == "0" then
			vim.cmd("CsvViewEnable header_lnum=none")
			return
		end

		local n = tonumber(input)
		if not n or n < 1 or math.floor(n) ~= n then
			vim.notify("Invalid header line number", vim.log.levels.ERROR)
			return
		end

		vim.cmd(string.format("CsvViewEnable header_lnum=%d", n))
	end)
end, { desc = "CSV: enable and choose header line" })

-----------------------------
-- Jupynvim (Jupyter Notebooks)
-----------------------------
vim.api.nvim_create_autocmd("FileType", {
	pattern = "ipynb",
	callback = function(args)
		local buf = args.buf

		-- Run cell under cursor
		vim.keymap.set("n", "<leader>jj", "<cmd>JupynvimRunCell<CR>", { buffer = buf, desc = "Run cell under cursor" })

		-- Run all cells in order
		vim.keymap.set("n", "<leader>ja", "<cmd>JupynvimRunAll<CR>", { buffer = buf, desc = "Run all cells" })

		-- Pick a Jupyter kernel
		vim.keymap.set("n", "<leader>jk", "<cmd>JupynvimKernel<CR>", { buffer = buf, desc = "Pick a kernel spec" })

		-- Restart active kernel
		vim.keymap.set("n", "<leader>jR", "<cmd>JupynvimRestart<CR>", { buffer = buf, desc = "Restart active kernel" })

		-- Clear outputs from all cells
		vim.keymap.set("n", "<leader>jc", "<cmd>JupynvimClearOutputs<CR>", { buffer = buf, desc = "Clear all outputs" })

		-- Clear output from current cell
		vim.keymap.set(
			"n",
			"<leader>jC",
			"<cmd>JupynvimClearCellOutput<CR>",
			{ buffer = buf, desc = "Clear current cell output" }
		)

		-- Run current cell
		vim.keymap.set("n", "<S-Enter>", "<cmd>JupynvimRunCell<CR>", { buffer = buf, desc = "Run cell" })
	end,
})
