return {
	"3rd/image.nvim",
	event = "VeryLazy",

	opts = {
		backend = "kitty", -- required for your setup

		-- =========================================
		-- Image sizing (Molten outputs)
		-- =========================================
		max_width = 100, -- width in terminal columns
		-- max_height = 40, -- height in terminal lines

		-- scale relative to window (important for splits)
		max_width_window_percentage = 140,
		max_height_window_percentage = 80,

		-- =========================================
		-- Performance / behavior
		-- =========================================
		hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },

		-- =========================================
		-- Integrations (important for Molten)
		-- =========================================
		integrations = {
			markdown = {
				enabled = false,
			},
			neorg = {
				enabled = false,
			},
		},
	},
}
