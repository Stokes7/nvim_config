return {
	"benlubas/molten-nvim",
	version = "^1.0.0",
	build = ":UpdateRemotePlugins",
	ft = { "python" },
	dependencies = {
		"willothy/wezterm.nvim",
	},

	init = function()
		-- Automatically prompt/init a kernel when needed
		vim.g.molten_auto_init_behavior = "init"

		-- Keep output window manual to avoid constant popups
		vim.g.molten_auto_open_output = false

		-- When entering output, open it and move cursor into it
		vim.g.molten_enter_output_behavior = "open_and_enter"

		-- Show output inline
		vim.g.molten_virt_text_output = true

		-- Show output also as virtual lines
		vim.g.molten_output_virt_lines = true

		-- Limit inline output size
		vim.g.molten_virt_text_max_lines = 20

		-- Wrap long outputs
		vim.g.molten_wrap_output = true

		-- Floating output window max height
		vim.g.molten_output_win_max_height = 20

		-- Slightly cleaner floating window look
		vim.g.molten_output_crop_border = true

		-- Hide execution time
		vim.g.molten_output_show_exec_time = false

		-- Do not auto-copy output
		vim.g.molten_copy_output = false

		-- Use WezTerm as image provider
		vim.g.molten_image_provider = "wezterm"

		-- Open images in a split on the right
		--vim.g.molten_split_direction = nil
		--vim.g.molten_split_size = 40
	end,

	config = function()
		require("wezterm").setup({
			create_new_pane = false,
		})
		local cell_pattern = "^%s*#%s*%%"

		local function is_python()
			return vim.bo.filetype == "python"
		end

		local function get_all_cells()
			local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
			local cells = {}
			local starts = {}

			for i, line in ipairs(lines) do
				if line:match(cell_pattern) then
					table.insert(starts, i)
				end
			end

			if #starts == 0 then
				if #lines > 0 then
					return { { 1, #lines } }
				else
					return {}
				end
			end

			for idx, start_line in ipairs(starts) do
				local end_line
				if idx < #starts then
					end_line = starts[idx + 1] - 1
				else
					end_line = #lines
				end
				table.insert(cells, { start_line, end_line })
			end

			return cells
		end

		local function get_current_cell()
			local cells = get_all_cells()
			local row = vim.api.nvim_win_get_cursor(0)[1]

			for _, cell in ipairs(cells) do
				local start_line, end_line = cell[1], cell[2]
				if row >= start_line and row <= end_line then
					return start_line, end_line
				end
			end

			return nil, nil
		end

		local function goto_next_cell()
			local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
			local row = vim.api.nvim_win_get_cursor(0)[1]

			for i = row + 1, #lines do
				if lines[i]:match(cell_pattern) then
					vim.api.nvim_win_set_cursor(0, { i, 0 })
					return
				end
			end
		end

		local function goto_prev_cell()
			local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
			local row = vim.api.nvim_win_get_cursor(0)[1]

			for i = row - 1, 1, -1 do
				if lines[i]:match(cell_pattern) then
					vim.api.nvim_win_set_cursor(0, { i, 0 })
					return
				end
			end
		end

		local function molten_init()
			vim.cmd("MoltenInit")
		end

		local function run_cell()
			if not is_python() then
				vim.notify("Molten cell runner is for Python files only")
				return
			end

			local start_line, end_line = get_current_cell()
			if not start_line or not end_line then
				vim.notify("No Python cell found")
				return
			end

			vim.fn.MoltenEvaluateRange(start_line, end_line)
		end

		local function run_and_next()
			run_cell()
			goto_next_cell()
		end

		local function run_all_cells()
			if not is_python() then
				vim.notify("Run-all is configured for Python files only")
				return
			end

			local cells = get_all_cells()
			if #cells == 0 then
				vim.notify("No cells found")
				return
			end

			for _, cell in ipairs(cells) do
				vim.fn.MoltenEvaluateRange(cell[1], cell[2])
			end
		end

		local function clear_current_cell_output()
			vim.cmd("MoltenDelete")
		end

		local function clear_all_cells_outputs()
			vim.cmd("MoltenDelete!")
		end

		local function restart_and_clear_all()
			vim.cmd("MoltenRestart!")
		end

		vim.keymap.set("n", "<leader>ji", molten_init, { desc = "Molten Init Kernel" })
		vim.keymap.set("n", "<leader>jl", "<cmd>MoltenEvaluateLine<CR>", { desc = "Run Line" })
		vim.keymap.set("n", "<leader>jr", "<cmd>MoltenReevaluateCell<CR>", { desc = "Re-run Active Cell" })
		vim.keymap.set("n", "<leader>jo", "<cmd>noautocmd MoltenEnterOutput<CR>", { desc = "Open Output" })
		vim.keymap.set("n", "<leader>jh", "<cmd>MoltenHideOutput<CR>", { desc = "Hide Output" })
		vim.keymap.set("n", "<leader>jx", "<cmd>MoltenRestart<CR>", { desc = "Restart Kernel" })
		vim.keymap.set("n", "<leader>jk", "<cmd>MoltenInterrupt<CR>", { desc = "Interrupt Kernel" })

		vim.keymap.set("n", "<leader>jj", run_cell, { desc = "Run Current Cell" })
		vim.keymap.set("n", "<S-Enter>", run_and_next, { desc = "Run Cell and Go Next" })
		vim.keymap.set("n", "<leader>ja", run_all_cells, { desc = "Run All Cells" })

		vim.keymap.set("n", "]j", goto_next_cell, { desc = "Next Cell" })
		vim.keymap.set("n", "[j", goto_prev_cell, { desc = "Previous Cell" })

		vim.keymap.set("v", "<leader>jv", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "Run Selection" })
		vim.keymap.set("n", "<leader>je", "<cmd>MoltenEvaluateOperator<CR>", { desc = "Operator Eval" })

		vim.keymap.set("n", "<leader>jc", clear_current_cell_output, { desc = "Clear Current Cell Output" })
		vim.keymap.set("n", "<leader>jC", clear_all_cells_outputs, { desc = "Clear All Cells Outputs" })
		vim.keymap.set("n", "<leader>jR", restart_and_clear_all, { desc = "Restart Kernel and Clear Outputs" })
	end,
}
