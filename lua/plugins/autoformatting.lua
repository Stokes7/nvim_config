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
				"stylua", -- Lua
				"shfmt", -- Bash
				"isort", -- Python imports
				"ruff", -- Python formatter & linter
				"clang-format", -- C / C++
				"fprettify", -- Fortran
				"checkmake", -- Makefiles
				--"prettier", -- HTML, JSON, YAML, Markdown
			},
			auto_update = true,
			run_on_start = true,
		})

		null_ls.setup({
			sources = {
				diagnostics.checkmake, -- Makefiles

				formatting.prettier.with({
					filetypes = { "html", "json", "yaml", "markdown" },
				}),

				formatting.stylua, -- Lua
				formatting.shfmt.with({ extra_args = { "-i", "4" } }), -- Bash

				-- Python
				-- require("none-ls.diagnostics.ruff"), -- Python lint
				require("none-ls.formatting.ruff").with({ -- Python format
					extra_args = { "--extend-select", "I" },
				}),
				formatting.isort, -- organize imports

				-- C / C++
				formatting.clang_format.with({
					extra_args = { "--style=file" }, -- or google, LLVM, Mozilla, WebKit, etc.
				}),

				-- Fortran
				formatting.fprettify.with({
					filetypes = { "fortran" }, -- o { "fortran", "f90", "f95" } si los tienes así
				}),
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
