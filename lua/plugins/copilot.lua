return {
	"zbirenbaum/copilot.lua",
	-- InsertEnter is too late: `:Copilot auth` fails silently when no client is attached yet
	event = { "BufReadPost", "BufNewFile" },
	cmd = "Copilot",
	opts = {
		panel = { enabled = false }, -- suggestions are shown as inline virtual text
		suggestion = {
			enabled = true,
			auto_trigger = true,
			hide_during_completion = false, -- keep the ghost text while the cmp menu is open, or accept passes the key through
			keymap = {
				-- kitty owns alt+hjkl (neighboring_window), so <M-l> never reaches nvim
				accept = "<C-l>",
				next = "<M-]>",
				prev = "<M-[>",
				dismiss = "<C-]>",
			},
		},
		-- Copilot disables prose filetypes by default
		filetypes = { tex = true, markdown = true, typst = true, gitcommit = true },
	},
	config = function(_, opts)
		require("copilot").setup(opts)
		vim.keymap.set("n", "<leader>ai", "<cmd>Copilot toggle<CR>", { desc = "Toggle Copilot", silent = true })
	end,
}
