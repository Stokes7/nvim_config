return {
	"hat0uma/csvview.nvim",
	cmd = {
		"CsvViewEnable",
		"CsvViewDisable",
		"CsvViewToggle",
		"CsvViewInfo",
	},
	opts = {
		parser = {
			async_chunksize = 50,

			delimiter = {
				ft = {
					csv = ",",
					tsv = "\t",
				},
				fallbacks = {
					",",
					"\t",
					";",
					"|",
					":",
				},
			},

			quote_char = '"',
			comments = { "#", "//" },
			comment_lines = nil,
			max_lookahead = 50,
		},

		view = {
			min_column_width = 8,
			spacing = 2,
			display_mode = "highlight",
			header_lnum = 1,

			sticky_header = {
				enabled = true,
				separator = "─",
			},
		},

		keymaps = {
			textobject_field_inner = { "if", mode = { "o", "x" } },
			textobject_field_outer = { "af", mode = { "o", "x" } },

			jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
			jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
			jump_next_row = { "]r", mode = { "n", "v" } },
			jump_prev_row = { "[r", mode = { "n", "v" } },
		},
	},

	config = function(_, opts)
		require("csvview").setup(opts)
	end,
}
