return {
	"epwalsh/obsidian.nvim",
	version = "*", -- Use latest stable release
	lazy = true,
	ft = "markdown", -- Only load the plugin when opening a .md file
	dependencies = {
		"nvim-lua/plenary.nvim",      -- Required
		"nvim-telescope/telescope.nvim", -- For search pickers
		"hrsh7th/nvim-cmp",           -- To autocomplete [[links]] and #tags
	},
	opts = {
		-- ─── Workspaces (vaults) ─────────────────────────────────────────
		workspaces = {
			{
				name = "personal",
				path = "~/Documents/obsidian-vault",
			},
		},

		-- ─── Daily Notes ─────────────────────────────────────────────────
		daily_notes = {
			folder = "daily",           -- Subfolder within the vault
			date_format = "%Y-%m-%d",   -- File name format
			default_tags = { "daily" }, -- Tags added automatically
		},

		-- ─── Completion ──────────────────────────────────────────────────
		completion = {
			nvim_cmp = true, -- Enable autocomplete with nvim-cmp
			min_chars = 2,   -- Minimum characters to show the menu
		},

		-- ─── Mappings ────────────────────────────────────────────────────
		mappings = {
			-- Follow a link (like 'gf' but for Obsidian wiki-links)
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true, desc = "Follow obsidian link" },
			},
			-- Toggle checkboxes: - [ ] → - [x] → - [-] → ...
			["<leader>oc"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true, desc = "Toggle checkbox" },
			},
			-- Open note in Obsidian app
			["<leader>oo"] = {
				action = "<cmd>ObsidianOpen<CR>",
				opts = { buffer = true, desc = "Open in Obsidian app" },
			},
			-- Create a new note
			["<leader>on"] = {
				action = "<cmd>ObsidianNew<CR>",
				opts = { buffer = true, desc = "New Obsidian note" },
			},
			-- Search text in notes (requires ripgrep)
			["<leader>os"] = {
				action = "<cmd>ObsidianSearch<CR>",
				opts = { buffer = true, desc = "Search text in notes" },
			},
			-- Quick note switcher (Telescope)
			["<leader>of"] = {
				action = "<cmd>ObsidianQuickSwitch<CR>",
				opts = { buffer = true, desc = "Find/Quick switch note" },
			},
			-- Show backlinks
			["<leader>ob"] = {
				action = "<cmd>ObsidianBacklinks<CR>",
				opts = { buffer = true, desc = "Show backlinks" },
			},
			-- Today's note
			["<leader>ot"] = {
				action = "<cmd>ObsidianToday<CR>",
				opts = { buffer = true, desc = "Today's daily note" },
			},
			-- Yesterday's note
			["<leader>oy"] = {
				action = "<cmd>ObsidianYesterday<CR>",
				opts = { buffer = true, desc = "Yesterday's daily note" },
			},
			-- Tomorrow's note
			["<leader>ow"] = {
				action = "<cmd>ObsidianTomorrow<CR>",
				opts = { buffer = true, desc = "Tomorrow's daily note" },
			},
			-- Insert template
			["<leader>oi"] = {
				action = "<cmd>ObsidianTemplate<CR>",
				opts = { buffer = true, desc = "Insert template" },
			},
			-- Create a link (link text to note)
			["<leader>ol"] = {
				action = "<cmd>ObsidianLink<CR>",
				opts = { buffer = true, desc = "Link text to note" },
			},
			-- Create note and link it
			["<leader>oln"] = {
				action = "<cmd>ObsidianLinkNew<CR>",
				opts = { buffer = true, desc = "Link text to new note" },
			},
		},

		-- ─── UI ──────────────────────────────────────────────────────────
		ui = {
			enable = true,
			-- Checkbox icons
			checkboxes = {
				[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
				["x"] = { char = "", hl_group = "ObsidianDone" },
				[">"] = { char = "", hl_group = "ObsidianRightArrow" },
				["-"] = { char = "󰥔", hl_group = "ObsidianTilde" },
			},
			bullets = { char = "•", hl_group = "ObsidianBullet" },
			external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
			reference_text = { hl_group = "ObsidianRefText" },
			highlight_text = { hl_group = "ObsidianHighlightText" },
			tags = { hl_group = "ObsidianTag" },
			hl_groups = {
				ObsidianTodo      = { bold = true, fg = "#f78c6c" },
				ObsidianDone      = { bold = true, fg = "#89ddff" },
				ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
				ObsidianTilde     = { bold = true, fg = "#ff5370" },
				ObsidianBullet    = { bold = true, fg = "#89ddff" },
				ObsidianRefText   = { underline = true, fg = "#c792ea" },
				ObsidianExtLinkIcon = { fg = "#c792ea" },
				ObsidianTag       = { italic = true, fg = "#89ddff" },
				ObsidianHighlightText = { bg = "#75662e" },
			},
		},

		-- ─── Templates ───────────────────────────────────────────────────
		templates = {
			folder = "PERSONAL/Templates",          -- Subfolder within the vault
			date_format = "%d.%m.%Y",
			time_format = "%H:%M",
		},

		-- ─── Pasted Images ───────────────────────────────────────────────
		attachments = {
			img_folder = "assets/imgs",   -- Subfolder where images are saved
		},
	},
}
