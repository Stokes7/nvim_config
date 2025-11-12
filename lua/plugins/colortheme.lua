return {
	"olimorris/onedarkpro.nvim",
	priority = 1000,
	config = function()
		local transparency_enabled = true

		require("onedarkpro").setup({
			options = {
				transparency = transparency_enabled,
			},
			colors = {
				red = "#FF4D4D",
			},
		})

		vim.cmd("colorscheme onedark_dark")

		-- Highlight constrast
		local function set_strong_visual()
			vim.api.nvim_set_hl(0, "Visual", { bg = "#5a4a78", fg = "#ffffff", bold = false })
			vim.api.nvim_set_hl(0, "VisualNOS", { bg = "#5a4a78", fg = "#ffffff", bold = false })
		end

		set_strong_visual()

		-- Replicate color if the scheme changes
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = set_strong_visual,
		})

		-- Alternate transparency
		local toggle_transparency = function()
			transparency_enabled = not transparency_enabled
			require("onedarkpro").setup({
				options = {
					transparency = transparency_enabled,
				},
				colors = {
					red = "#FF4D4D",
				},
			})
			vim.cmd("colorscheme onedark_dark")
			set_strong_visual()
		end

		vim.keymap.set("n", "<leader>bg", toggle_transparency, { noremap = true, silent = true })
	end,
}
