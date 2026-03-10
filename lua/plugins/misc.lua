-- Standalone plugins with less than 10 lines of config go here
return {
	{
		-- Tmux & split window navigation
		"christoomey/vim-tmux-navigator",
		lazy = false,
		-- "mrjones2014/smart-splits.nvim",
		-- lazy = false, -- <- clave: cargar siempre al inicio
		-- config = function()
		-- 	require("smart-splits").setup({
		-- 		-- tu config opcional aquí
		-- 	})
		-- end,
	},
	{
		-- Detect tabstop and shiftwidth automatically
		"tpope/vim-sleuth",
	},
	{
		-- Powerful Git integration for Vim
		"tpope/vim-fugitive",
		cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "GBrowse" },
	},
	{
		-- GitHub integration for vim-fugitive
		"tpope/vim-rhubarb",
		cmd = { "GBrowse" },
	},
	{
		-- Hints keybinds
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			wk.setup({})
			wk.add({
				{ "<leader>b", group = "buffer" },
				{ "<leader>c", group = "code" },
				{ "<leader>d", group = "diagnostics" },
				{ "<leader>f", group = "file" },
				{ "<leader>g", group = "git" },
				{ "<leader>m", group = "markup" },
				{ "<leader>n", group = "neo-tree" },
				{ "<leader>s", group = "search" },
				{ "<leader>t", group = "tab" },
				{ "<leader>u", group = "toggle / ui" },
				{ "<leader>w", group = "window" },
				{ "<leader>x", group = "delete" },
			})
		end,
	},
	{
		-- Autoclose parentheses, brackets, quotes, etc.
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		opts = {},
	},
	{
		-- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		-- High-performance color highlighter
		"norcalli/nvim-colorizer.lua",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("colorizer").setup()
		end,
	},
}
