-- Standalone plugins with less than 10 lines of config go here
return {
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
				{ "<leader>b", group = "buffer", icon = { icon = "󰓩 ", color = "cyan" } },
				{ "<leader>l", group = "leetcode", icon = { icon = "󰛱 ", color = "yellow" } },
				{ "<leader>v", group = "csv", icon = { icon = " ", color = "green" } },
				{ "<leader>j", group = "jupyter", icon = { icon = "󱗕 ", color = "orange" } },
				{ "<leader>d", group = "diagnostics", icon = { icon = " ", color = "red" } },
				{ "<leader>f", group = "file", icon = { icon = "󰈞 ", color = "blue" } },
				{ "<leader>g", group = "git", icon = { icon = " ", color = "orange" } },
				{ "<leader>m", group = "markup", icon = { icon = " ", color = "cyan" } },
				{ "<leader>n", group = "neo-tree", icon = { icon = "󰙅 ", color = "green" } },
				{ "<leader>s", group = "search", icon = { icon = " ", color = "blue" } },
				{ "<leader>t", group = "tab", icon = { icon = "󰓩 ", color = "purple" } },
				{ "<leader>u", group = "toggle / ui", icon = { icon = " ", color = "yellow" } },
				{ "<leader>w", group = "window", icon = { icon = " ", color = "azure" } },
				{ "<leader>x", group = "delete", icon = { icon = "󰆴 ", color = "red" } },
				{ "<leader>a", group = "autocomplete / AI", icon = { icon = " ", color = "purple" } },
				{ "<leader>c", group = "code / lsp", icon = { icon = " ", color = "azure" } },
				{ "<leader>o", group = "obsidian", icon = { icon = "󱋩 ", color = "purple" } },
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
