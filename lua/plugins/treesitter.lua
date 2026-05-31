return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
	main = "nvim-treesitter",
	opts = {
		-- Solo install_dir está soportado en el nuevo setup()
		-- Los parsers se instalan via :TSInstall o programáticamente abajo
	},
	config = function(_, opts)
		require("nvim-treesitter").setup(opts)

		-- Equivalent to the old ensure_installed
		local langs = {
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
		}
		require("nvim-treesitter").install(langs)
	end,
}
