-- Gather conflicts for a given mode and return them sorted
local function gather_conflicts_for_mode(mode)
	local maps = vim.api.nvim_get_keymap(mode)
	local by_lhs = {}
	for _, m in ipairs(maps) do
		local lhs = m.lhs
		by_lhs[lhs] = by_lhs[lhs] or {}
		table.insert(by_lhs[lhs], m)
	end
	local conflicts = {}
	for lhs, items in pairs(by_lhs) do
		if #items > 1 then
			table.insert(conflicts, { lhs = lhs, items = items })
		end
	end
	table.sort(conflicts, function(a, b)
		return a.lhs < b.lhs
	end)
	return conflicts
end

local mode_labels = {
	n = "NORMAL",
	i = "INSERT",
	v = "VISUAL",
	x = "VISUAL (operator)",
	s = "SELECT",
	o = "OP-PENDING",
	t = "TERMINAL",
}

vim.api.nvim_create_user_command("CheckKeymapConflicts", function()
	local modes = { "n", "i", "v", "x", "s", "o", "t" }

	-- Collect conflicts
	local any_conflict = false
	local lines = {}
	table.insert(lines, "Keymap Conflicts Report")
	table.insert(lines, "=======================")

	for _, md in ipairs(modes) do
		local conflicts = gather_conflicts_for_mode(md)
		if #conflicts > 0 then
			any_conflict = true
			table.insert(lines, "")
			table.insert(lines, ("[%s]"):format(mode_labels[md] or md))
			for _, c in ipairs(conflicts) do
				table.insert(lines, ("  %s  <-- (%d mappings)"):format(c.lhs, #c.items))
				for _, m in ipairs(c.items) do
					local rhs = m.rhs or "<lua/expr>"
					local desc = m.desc and (" — " .. m.desc) or ""
					table.insert(lines, ("      ↳ %s%s"):format(rhs, desc))
				end
			end
		end
	end

	if not any_conflict then
		vim.notify("✅ No keymap conflicts detected in the checked modes.", vim.log.levels.INFO)
		return
	end

	-- Open a scratch buffer and dump the report
	local buf = vim.api.nvim_create_buf(false, true) -- unlisted, scratch
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].filetype = "keymaps"
	vim.api.nvim_set_current_buf(buf)
end, { desc = "Check for duplicated keymap conflicts across modes" })
