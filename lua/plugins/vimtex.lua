return {
	"lervag/vimtex",
	ft = "tex",
	init = function()
		-- Viewer + sync
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_compiler_progname = "nvr" -- enables inverse search to the *current* Neovim

		-- Compiler (continuous) via latexmk
		vim.g.vimtex_compiler_method = "latexmk"
		vim.g.vimtex_compiler_latexmk = {
			callback = 1,
			continuous = 1,
			executable = "latexmk",
			options = {
				"-pdf",
				"-interaction=nonstopmode",
				"-synctex=1",
				"-auxdir=src", -- ← auxiliares a ./src
				-- "-outdir=."    -- opcional, por defecto ya es el directorio actual
			},
		}

		-- QoL
		vim.g.vimtex_quickfix_mode = 0
		--vim.g.maplocalleader = "\\"
	end,
}
