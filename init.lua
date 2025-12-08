-----------------------------
-- Keymaps
-----------------------------
require("core.keymaps")

-----------------------------
-- Keymaps Checker
-----------------------------
require("core.keyMapsChecker")

-----------------------------
-- Core Options
-----------------------------
require("core.options")

-----------------------------
-- Bootstrap lazy.nvim
-----------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Clone lazy.nvim if not installed
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

-- Add lazy.nvim to runtimepath
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-----------------------------
-- Plugin Setup (lazy.nvim)
-----------------------------
require("lazy").setup({

	-----------------------------
	-- Neo-tree (file explorer)
	-----------------------------
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		lazy = false,
	},

	-----------------------------
	-- Plugin Modules
	-----------------------------
	require("plugins.colortheme"),
	require("plugins.neotree"),
	require("plugins.bufferline"),
	require("plugins.lualine"),
	require("plugins.telescope"),
	require("plugins.treesitter"),
	require("plugins.lsp"),
	require("plugins.autocompletion"),
	require("plugins.autoformatting"),
	require("plugins.gitsigns"),
	require("plugins.alpha"),
	require("plugins.indent-blankline"),
	require("plugins.misc"),
	require("plugins.typst"),
	-- require("plugins.vimtex"),
	-- require("plugins.nvchadui"),
	-- require("plugins.nvchad_neotree"),
})
