-- Standalone plugins with less than 10 lines of config go here
return {
	{
		-- Tmux & split window navigation
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft", "TmuxNavigateDown",
			"TmuxNavigateUp", "TmuxNavigateRight", "TmuxNavigatePrevious",
		},
		keys = {
			{ "<C-h>", "<cmd>TmuxNavigateLeft<CR>",  desc = "Window left" },
			{ "<C-j>", "<cmd>TmuxNavigateDown<CR>",  desc = "Window down" },
			{ "<C-k>", "<cmd>TmuxNavigateUp<CR>",    desc = "Window up" },
			{ "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Window right" },
		},
		init = function()
			vim.g.tmux_navigator_no_mappings = 1
		end,
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
				{ "<leader>l", group = "leetcode" },
				{ "<leader>v", group = "csv" },
				{ "<leader>j", group = "jupyter" },
				{ "<leader>d", group = "diagnostics" },
				{ "<leader>f", group = "file" },
				{ "<leader>g", group = "git" },
				{ "<leader>m", group = "markup" },
				{ "<leader>e", group = "explorer" },
				{ "<leader>n", group = "neo-tree" },
				{ "<leader>s", group = "search" },
				{ "<leader>t", group = "tab" },
				{ "<leader>u", group = "toggle / ui" },
				{ "<leader>w", group = "window" },
				{ "<leader>x", group = "delete" },
				{ "<leader>a", group = "autocomplete / AI" },
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
