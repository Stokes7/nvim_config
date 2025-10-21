-- lua/plugins/nvchad_ui.lua
return {
	"NvChad/ui",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-tree/nvim-web-devicons", lazy = true },
		{
			"NvChad/base46",
			lazy = true,
			build = function()
				require("base46").load_all_highlights()
			end,
		},
	},
	config = function()
		-- Cache folder for highlights
		vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache"
		vim.g.base46_theme = "onedark" -- change theme here

		-- Generate highlights if cache folder is missing
		if vim.fn.isdirectory(vim.g.base46_cache) == 0 then
			require("base46").load_all_highlights()
		end

		-- Load all cached highlight files
		for _, f in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
			dofile(vim.g.base46_cache .. "/" .. f)
		end

		-- Start NvChad UI (tabufline, statusline, etc.)
		require("nvchad")
	end,
}
