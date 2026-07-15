return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
	main = "nvim-treesitter",
	opts = {
		-- Solo install_dir está soportado en el nuevo setup()
		-- Los parsers se instalan via :TSInstall o programáticamente abajo
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
				"fortran",
				"cpp",
				"cmake",
				"make",
				"python",
				"typst",
				"latex",
				"bibtex",
				"json",
			},
			highlight = {
				enable = true,
			},
		})
	end,
}
