-- NOTE: neoscroll + kitty graphics need coordination.
-- image.nvim repositions/clears its kitty placements on `WinScrolled`, but
-- neoscroll suppresses that event during the animation (see ignored_events).
-- Result: you scroll while an image is on screen, the buffer text moves but the
-- image placement doesn't -> frozen image / torn halves stuck in the terminal.
--
-- Fix: hide images for the duration of the animation and re-render once it
-- ends. Scrolling stays smooth (no per-frame image redraw) and nothing is left
-- behind, because the images are actually cleared, not just overdrawn.

local images_were_enabled = false

local function suspend_images()
	local ok, image = pcall(require, "image")
	if not ok then
		return
	end
	if image.is_enabled() then
		images_were_enabled = true
		image.disable()
	end
end

local function resume_images()
	if not images_were_enabled then
		return
	end
	images_were_enabled = false
	local ok, image = pcall(require, "image")
	if ok then
		image.enable()
	end
end

-- The mouse wheel never reaches neoscroll -- it only maps <C-u>/<C-d>/<C-f>/
-- <C-b>/<C-y>/<C-e>/zt/zz/zb, not <ScrollWheelUp>/<ScrollWheelDown>. So the
-- wheel still hits the raw path: every tick fires WinScrolled, image.nvim
-- answers each one, and it writes kitty escape sequences straight to fd 1 via
-- its own tty handle (backends/kitty/helpers.lua: `vim.loop.new_tty(1, false)`),
-- independently of nvim's TUI renderer. Its scheduler only coalesces per event
-- loop tick, with no time-based throttle, so spinning the wheel fast interleaves
-- those writes with nvim's screen output. Kitty renders the fragments it can't
-- parse as literal text -- the garbage characters in the neo-tree panel.
--
-- Same treatment as the animation: drop the images while the wheel is spinning,
-- restore them once it stops, and force a full repaint to wipe any leftovers.
local resume_timer = nil

local function schedule_resume()
	if resume_timer then
		resume_timer:stop()
	else
		resume_timer = (vim.uv or vim.loop).new_timer()
	end
	resume_timer:start(
		150,
		0,
		vim.schedule_wrap(function()
			vim.cmd("mode") -- full repaint; clears half-parsed escape sequences
			resume_images()
		end)
	)
end

local function wheel(key)
	local keycode = vim.keycode(key)
	return function()
		suspend_images()
		schedule_resume()
		-- "n" = no remap, so this runs the built-in wheel behaviour (including
		-- scrolling whichever window the pointer is over) instead of recursing.
		vim.api.nvim_feedkeys(keycode, "n", false)
	end
end

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
		pre_hook = suspend_images, -- Clear kitty images before the animation
		post_hook = function(info)
			if info == "center" then
				vim.cmd("normal! zz")
			end
			resume_images()
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
			neoscroll.ctrl_d({ duration = 250, info = "center" })
		end, { silent = true, desc = "Scroll down and center" })
		vim.keymap.set("n", "<C-u>", function()
			neoscroll.ctrl_u({ duration = 250, info = "center" })
		end, { silent = true, desc = "Scroll up and center" })

		-- Safety net: if an animation is interrupted (<C-c>, a mapping that
		-- bails early) post_hook may never fire and images would stay off.
		-- Re-enable them as soon as the editor goes idle.
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = vim.api.nvim_create_augroup("neoscroll_image_rescue", { clear = true }),
			callback = resume_images,
		})

		for _, key in ipairs({ "<ScrollWheelUp>", "<ScrollWheelDown>" }) do
			vim.keymap.set({ "n", "v", "i" }, key, wheel(key), { desc = "Scroll (image-safe)" })
		end
	end,
}
