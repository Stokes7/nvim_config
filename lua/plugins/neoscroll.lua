return {
	"karb94/neoscroll.nvim",
	opts = {
		mappings = { -- <C-u>/<C-d> are bound below so they can recenter afterwards
			"<C-b>",
			"<C-f>",
			"<C-y>",
			"<C-e>",
			"zt",
			"zz",
			"zb",
		},
		hide_cursor = true, -- Hide cursor while scrolling
		stop_eof = true, -- Stop at <EOF> when scrolling downwards
		respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
		cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
		duration_multiplier = 0.7, -- Global duration multiplier
		easing = "linear", -- Default easing function
		pre_hook = nil, -- Function to run before the scrolling animation starts
		post_hook = function(info)
			if info == "center" then
				vim.cmd("normal! zz")
			end
		end,
		performance_mode = false, -- Disable "Performance Mode" on all buffers.
		ignored_events = { -- Events ignored while scrolling
			"WinScrolled",
			"CursorMoved",
		},
	},
	config = function(_, opts)
		local neoscroll = require("neoscroll")
		neoscroll.setup(opts)
		vim.keymap.set("n", "<C-d>", function()
			neoscroll.ctrl_d({ info = "center" })
		end, { silent = true, desc = "Scroll down and center" })
		vim.keymap.set("n", "<C-u>", function()
			neoscroll.ctrl_u({ info = "center" })
		end, { silent = true, desc = "Scroll up and center" })
	end,
}
