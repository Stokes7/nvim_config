-- Autoformatting & linters via none-ls
return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim", -- ruff integration
		{ "williamboman/mason.nvim", opts = {} }, -- official Mason
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics

		-- Ensure external tools are installed (no mason-null-ls needed)
		require("mason-tool-installer").setup({
			ensure_installed = {
				--"prettier",
				"stylua",
				"shfmt",
				--"clang-format",
				--"cmakelang",
				"checkmake",
				--"ruff",
			},
			auto_update = true,
			run_on_start = true,
		})

		null_ls.setup({
			sources = {
				diagnostics.checkmake, -- Makefiles

				formatting.prettier.with({ -- HTML/JSON/YAML/Markdown
					filetypes = { "html", "json", "yaml", "markdown" },
				}),

				formatting.stylua, -- Lua
				formatting.shfmt.with({ extra_args = { "-i", "4" } }), -- Bash
				--formatting.clang_format,                         -- C/C++
				--formatting.cmake_format, -- CMake

				--require("none-ls.diagnostics.ruff"), -- Python lint
				require("none-ls.formatting.ruff").with({
					extra_args = {
						"--select",
						"I",
						"--ignore",
						"F401,F841",
						"--fix",
						"true",
					},
				}),

				formatting.fprettify, -- Fortran
			},
		})

		-- Optional: format-on-save only if none-ls provides a formatter for the buffer
		vim.api.nvim_create_autocmd("BufWritePre", {
			callback = function(args)
				local has = false
				for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
					if c.name == "null-ls" and c.supports_method("textDocument/formatting") then
						has = true
						break
					end
				end
				if has then
					vim.lsp.buf.format({ bufnr = args.buf, async = false, name = "null-ls" })
				end
			end,
		})
	end,
}
