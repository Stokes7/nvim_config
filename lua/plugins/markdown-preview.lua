return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
	ft = "markdown",
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
		-- Open preview in Zen Browser in a private window
		vim.g.mkdp_browserfunc = "v:lua.open_markdown_preview"
		_G.open_markdown_preview = function(url)
			local cmd = vim.fn.executable("zen-browser") == 1
					and { "zen-browser", "--private-window", url }
				or { "xdg-open", url }
			vim.fn.jobstart(cmd, { detach = true })
		end
	end,
	keys = {
		{ "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", ft = "markdown", desc = "Toggle Markdown Preview (Browser)" },
	},
}
