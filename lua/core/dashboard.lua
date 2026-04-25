local M = {}

local ignored_filetypes = {
	alpha = true,
	dashboard = true,
	["neo-tree"] = true,
	["neo-tree-popup"] = true,
	snacks_dashboard = true,
}

M.exiting = false

function M.is_real_file_buffer(buf)
	if not vim.api.nvim_buf_is_valid(buf) then
		return false
	end

	if not vim.bo[buf].buflisted then
		return false
	end

	if vim.bo[buf].buftype ~= "" then
		return false
	end

	if ignored_filetypes[vim.bo[buf].filetype] then
		return false
	end

	local name = vim.api.nvim_buf_get_name(buf)

	if name == "" then
		return vim.bo[buf].modified
	end

	return true
end

function M.real_file_buffers()
	local buffers = {}

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if M.is_real_file_buffer(buf) then
			table.insert(buffers, buf)
		end
	end

	return buffers
end

function M.open_alpha_if_needed()
	if M.exiting then
		return
	end

	if vim.fn.exists(":Alpha") ~= 2 then
		return
	end

	local current = vim.api.nvim_get_current_buf()

	if vim.api.nvim_buf_is_valid(current) then
		local ft = vim.bo[current].filetype

		-- Only skip if already in alpha
		if ft == "alpha" then
			return
		end
	end

	-- If there are still real buffers → do nothing
	if #M.real_file_buffers() > 0 then
		return
	end

	pcall(vim.cmd, "silent! Alpha")
end

return M
