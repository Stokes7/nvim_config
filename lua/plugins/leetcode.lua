return {
	"kawre/leetcode.nvim",
	cmd = "Leet",
	-- build = ":TSUpdate html",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		lang = "cpp", -- o "python3", "java", etc.
	},
}
