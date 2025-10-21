-- lua/typst_tools.lua
local M = {}

local function pdf_of(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr)
	return name:gsub("%.typ$", ".pdf")
end

function M.build()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" or not file:match("%.typ$") then
		vim.notify("Open a .typ file first", vim.log.levels.WARN)
		return
	end
	vim.fn.jobstart({ "typst", "compile", file }, {
		stdout_buffered = true,
		on_exit = function(_, code)
			if code == 0 then
				vim.notify("Typst build succeeded")
			else
				vim.notify("Typst build failed", vim.log.levels.ERROR)
			end
		end,
	})
end

function M.watch()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" or not file:match("%.typ$") then
		vim.notify("Open a .typ file first", vim.log.levels.WARN)
		return
	end
	vim.fn.jobstart({ "typst", "watch", file }, { detach = true })
	vim.notify("Typst watcher started for " .. vim.fn.fnamemodify(file, ":t"))
end

function M.view()
	local pdf = pdf_of(0)
	if vim.fn.filereadable(pdf) == 0 then
		M.build()
	end
	vim.fn.jobstart({ "zathura", pdf }, { detach = true })
	vim.notify("Opened PDF in Zathura: " .. pdf)
end

return M
