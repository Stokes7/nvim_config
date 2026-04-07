return { -- Autocompletion
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		-- Snippet Engine & its associated nvim-cmp source
		{
			"L3MON4D3/LuaSnip",
			build = (function()
				-- Build Step is needed for regex support in snippets
				-- This step is not supported in many windows environments
				-- Remove the below condition to re-enable on windows
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
		},
		"saadparwaiz1/cmp_luasnip",

		-- Adds other completion capabilities.
		--  nvim-cmp does not ship with all sources by default. They are split
		--  into multiple repos for maintenance purposes.
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",

		-- Adds a number of user-friendly snippets
		"rafamadriz/friendly-snippets",
	},
	config = function()
		local cmp = require("cmp")
		require("luasnip.loaders.from_vscode").lazy_load()
		local luasnip = require("luasnip")
		luasnip.config.setup({})

		local kind_icons = {
			Text = "󰉿",
			Method = "m",
			Function = "󰊕",
			Constructor = "",
			Field = "",
			Variable = "󰆧",
			Class = "󰌗",
			Interface = "",
			Module = "",
			Property = "",
			Unit = "",
			Value = "󰎠",
			Enum = "",
			Keyword = "󰌋",
			Snippet = "",
			Color = "󰏘",
			File = "󰈙",
			Reference = "",
			Folder = "󰉋",
			EnumMember = "",
			Constant = "󰇽",
			Struct = "",
			Event = "",
			Operator = "󰆕",
			TypeParameter = "󰊄",
		}

		-- Estados globales
		vim.g.cmp_enabled = false
		vim.g.cmp_lsp_enabled = false
		vim.g.cmp_buffer_enabled = false
		vim.g.cmp_path_enabled = false
		vim.g.cmp_snippet_enabled = false

		local function get_sources()
			local sources = {}

			if vim.g.cmp_lsp_enabled then
				table.insert(sources, { name = "nvim_lsp" })
			end
			if vim.g.cmp_snippet_enabled then
				table.insert(sources, { name = "luasnip" })
			end
			if vim.g.cmp_buffer_enabled then
				table.insert(sources, { name = "buffer" })
			end
			if vim.g.cmp_path_enabled then
				table.insert(sources, { name = "path" })
			end

			return sources
		end

		local function setup_cmp()
			cmp.setup({
				enabled = function()
					return vim.g.cmp_enabled
				end,
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },
				mapping = cmp.mapping.preset.insert({
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-c>"] = cmp.mapping.complete({}),

					["<C-f>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),

					["<C-b>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = get_sources(),
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						vim_item.kind = string.format("%s", kind_icons[vim_item.kind] or "")
						vim_item.menu = ({
							codeium = "[AI]",
							nvim_lsp = "[LSP]",
							luasnip = "[Snippet]",
							buffer = "[Buffer]",
							path = "[Path]",
						})[entry.source.name]
						return vim_item
					end,
				},
			})
		end

		setup_cmp()

		-- Toggle global cmp
		vim.keymap.set("n", "<leader>ac", function()
			vim.g.cmp_enabled = not vim.g.cmp_enabled
			if not vim.g.cmp_enabled then
				cmp.abort()
			end
			print("cmp: " .. (vim.g.cmp_enabled and "ON" or "OFF"))
		end, { desc = "Toggle cmp" })

		-- Toggle LSP source
		vim.keymap.set("n", "<leader>al", function()
			vim.g.cmp_lsp_enabled = not vim.g.cmp_lsp_enabled
			setup_cmp()
			cmp.abort()
			print("cmp LSP: " .. (vim.g.cmp_lsp_enabled and "ON" or "OFF"))
		end, { desc = "Toggle cmp LSP source" })

		-- Toggle buffer source
		vim.keymap.set("n", "<leader>ab", function()
			vim.g.cmp_buffer_enabled = not vim.g.cmp_buffer_enabled
			setup_cmp()
			cmp.abort()
			print("cmp Buffer: " .. (vim.g.cmp_buffer_enabled and "ON" or "OFF"))
		end, { desc = "Toggle cmp Buffer source" })

		-- Toggle AI source dentro de cmp
		vim.keymap.set("n", "<leader>aa", function()
			vim.g.cmp_codeium_enabled = not vim.g.cmp_codeium_enabled
			setup_cmp()
			cmp.abort()
			print("cmp AI: " .. (vim.g.cmp_codeium_enabled and "ON" or "OFF"))
		end, { desc = "Toggle cmp AI source" })
	end,
}
