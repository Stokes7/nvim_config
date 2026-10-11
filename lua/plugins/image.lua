return {
	"3rd/image.nvim",
	event = "VeryLazy",

	opts = {
		backend = "kitty", -- required for your setup
		kitty_method = "normal",

		-- =========================================
		-- Image sizing (Molten outputs)
		-- =========================================
		-- max_width/max_height MUST be set: without them a huge image can
		-- flood kitty's graphics protocol and wedge/crash the terminal.
		max_width = 100, -- width in terminal columns
		max_height = 20, -- height in terminal lines (matches molten_virt_text_max_lines)

		-- Molten needs the *percentage* caps disabled, otherwise images get
		-- rescaled (instead of cropped) whenever the output window is partly
		-- off-screen -- that rescaling is what leaves torn/stale tiles behind.
		-- (140 was also invalid: anything > 100 draws outside the window.)
		max_width_window_percentage = math.huge,
		max_height_window_percentage = math.huge,

		-- =========================================
		-- Ghost-image prevention
		-- =========================================
		-- Clear images that get covered by a floating window (cmp menu,
		-- telescope, notifications, LSP hover). Without this the float paints
		-- over the image but kitty keeps the placement -> leftover fragments.
		window_overlap_clear_enabled = true,
		window_overlap_clear_ft_ignore = {
			"cmp_menu",
			"cmp_docs",
			"snacks_notif",
			"scrollview",
			"scrollview_sign",
			"",
		},

		-- Deliberately false: with `true`, image.nvim clears every image on
		-- FocusLost, so clicking on another window makes the plots vanish even
		-- though the terminal is still visible. Ghost images across kitty tabs
		-- are handled well enough by window_overlap_clear_enabled above plus
		-- the neoscroll hooks; if one ever gets stuck, use <leader>jz.
		editor_only_render_when_focused = false,
		tmux_show_only_in_active_window = false,

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
