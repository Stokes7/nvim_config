return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
	main = "nvim-treesitter",
	opts = {},
	config = function(_, opts)
		local ts = require("nvim-treesitter")
		ts.setup(opts)

		ts.install({
			"bash",
			"bibtex",
			"c",
			"cmake",
			"cpp",
			"diff",
			"fortran",
			"html",
			"json",
			"latex",
			"lua",
			"luadoc",
			"make",
			"markdown",
			"markdown_inline",
			"python",
			"query",
			"typst",
			"vim",
			"vimdoc",
		})

		-- The `main` branch does not enable anything on its own.
		-- VimTeX owns tex highlighting/conceal, so treesitter stays out of it.
		local no_highlight = { tex = true, latex = true }

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
			callback = function(args)
				local ft = vim.bo[args.buf].filetype
				if no_highlight[ft] then
					return
				end
				local lang = vim.treesitter.language.get_lang(ft)
				if lang and pcall(vim.treesitter.language.add, lang) then
					pcall(vim.treesitter.start, args.buf, lang)
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
