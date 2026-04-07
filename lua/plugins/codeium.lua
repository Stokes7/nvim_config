return {
	"Exafunction/codeium.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("codeium").setup({
			enable_cmp_source = false,
			virtual_text = {
				enabled = true,
			},
		})

		vim.keymap.set("n", "<leader>aw", "<cmd>Codeium Toggle<CR>", {
			desc = "Toggle Windsurf",
			silent = true,
		})
	end,
}
