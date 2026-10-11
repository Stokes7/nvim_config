return {
	"lervag/vimtex",
	ft = "tex",
	init = function()
		-- Disable default VimTeX keymaps (we define our own in keymaps.lua)
		vim.g.vimtex_mappings_enabled = 0

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
				"-auxdir=build", -- auxiliary files to ./build
				-- "-outdir=."    -- optional, current directory is default
			},
		}

		-- QoL
		vim.g.vimtex_quickfix_mode = 0
		--vim.g.maplocalleader = "\\"
	end,
}
