return {
	-- Own fork with image_fit (PR pending upstream); switch back to
	-- "sheng-tse/jupynvim" once it is merged
	"Stokes7/jupynvim",
	branch = "feat/image-fit",
	build = function(plugin)
		local install = loadfile(plugin.dir .. "/lua/jupynvim/install.lua")()
		install.run(plugin)
	end,
	config = function()
		local jn = require("jupynvim")
		jn.setup({
			log_level = "info",
			image_renderer = "placeholder", -- "placeholder", "kitty", or "chafa"
			explorer_keys = {}, -- Disable built-in explorer to avoid conflict with Neo-tree
			-- Plots as large as fit in 130 cols x 25 rows, keeping their aspect ratio,
			-- with no empty space around them
			-- (image_fit: local patch on branch feat/image-auto-rows, proposed upstream)
			image_rows = 25,
			image_cols = 130,
			image_fit = "auto",
		})

		-- Remember each notebook's kernel in b:jupynvim_kernel for lualine.
		-- jupynvim only reports the name in its "kernel 'X' started" message.
		-- Also: instead of auto-starting the notebook's default kernel, ask which one.
		local pending
		local start_kernel = jn.start_kernel
		jn.start_kernel = function(buf, name, ...)
			buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
			local nb = require("jupynvim.notebook").get(buf)
			if name == nil and nb and not nb.kernel_started and not nb.kernel_starting then
				return jn.kernel_picker(buf) -- calls start_kernel again with the chosen name
			end
			pending = buf
			return start_kernel(buf, name, ...)
		end
		local notify = vim.notify
		vim.notify = function(msg, ...)
			local name = type(msg) == "string" and msg:match("^jupynvim: kernel '(.-)' started")
			if name and pending and vim.api.nvim_buf_is_valid(pending) then
				vim.b[pending].jupynvim_kernel = name
			end
			return notify(msg, ...)
		end
	end,
}
