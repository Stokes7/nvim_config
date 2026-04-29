return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		local dashboard_utils = require("core.dashboard")

		vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#ff3b3b", bold = true })
		vim.api.nvim_set_hl(0, "DashboardButton", { fg = "#ffffff" })
		vim.api.nvim_set_hl(0, "DashboardShortcut", { fg = "#ff5c5c", bold = true })
		vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#ff5c5c", italic = true })

		math.randomseed(os.time())

		local function get_all_files_in_dir(dir)
			local files = {}
			local scan = vim.fn.globpath(dir, "**/*.lua", true, true)
			for _, file in ipairs(scan) do
				table.insert(files, vim.fs.normalize(file))
			end
			return files
		end

		local function load_random_header()
			local header_folder = vim.fs.normalize(vim.fn.stdpath("config") .. "/lua/alpha_images/")
			local files = get_all_files_in_dir(header_folder)

			if #files == 0 then
				vim.notify("Alpha: no .lua headers in " .. header_folder, vim.log.levels.WARN)
				return nil
			end

			local random_file = files[math.random(#files)]

			if not vim.startswith(random_file, header_folder) then
				vim.notify("Alpha: file not under folder: " .. random_file, vim.log.levels.WARN)
				return nil
			end

			local relative_path = random_file:sub(#header_folder + 1)
			local module_name = "alpha_images." .. relative_path:gsub("[/\\]", "."):gsub("%.lua$", "")

			package.loaded[module_name] = nil

			local ok, module = pcall(require, module_name)
			if not ok then
				vim.notify(
					"Alpha: require failed for " .. module_name .. " — " .. tostring(module),
					vim.log.levels.ERROR
				)
				return nil
			end

			if type(module) == "table" and module.header then
				return module.header
			elseif type(module) == "table" and module.type == "text" and module.val then
				return module
			else
				vim.notify("Alpha: " .. module_name .. " has no valid header", vim.log.levels.WARN)
				return nil
			end
		end

		local header = load_random_header() or dashboard.section.header

		dashboard.section.buttons.val = {
			dashboard.button("w", "󰏘  Change header image", function()
				local new_header = load_random_header()
				if new_header then
					header = new_header
					dashboard.config.layout[1].val = get_vertical_padding()
					dashboard.config.layout[2] = new_header
					pcall(vim.cmd.AlphaRedraw)
				end
			end),
			dashboard.button("c", "󰒓  Settings", ":e $HOME/.config/nvim/init.lua<CR>"),
			dashboard.button("r", "󰄉  Recent files", ":Telescope oldfiles<CR>"),
			dashboard.button("t", "󰆍  Practice typing", ":Typr<CR>"),
			dashboard.button("u", "󰚰  Update plugins", "<cmd>Lazy update<CR>"),
		}

		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "DashboardButton"
			button.opts.hl_shortcut = "DashboardShortcut"
		end

		function get_vertical_padding()
			local height = vim.fn.winheight(0)
			local header_height = type(header.val) == "table" and #header.val or 6
			local buttons_height = #dashboard.section.buttons.val
			local footer_height = 4

			local content_height = header_height + buttons_height + footer_height + 4
			local padding = math.floor((height - content_height) / 2)

			return math.max(padding, 1)
		end

		dashboard.config.layout = {
			{ type = "padding", val = get_vertical_padding() },
			header,
			{ type = "padding", val = 3 },
			{
				type = "group",
				val = {
					{
						type = "group",
						val = dashboard.section.buttons.val,
						opts = { spacing = 1 },
					},
				},
				opts = { layout = "horizontal" },
			},
			{ type = "padding", val = 2 },
			dashboard.section.footer,
		}

		vim.api.nvim_create_autocmd("User", {
			pattern = "VimStarted",
			once = true,
			callback = function()
				local stats = require("lazy").stats()
				local ms = math.floor(stats.startuptime * 100 + 0.5) / 100

				dashboard.section.footer.val = {
					" ",
					" ",
					" ",
					" Loaded " .. stats.count .. " plugins  in " .. ms .. " ms ",
				}

				dashboard.section.footer.opts = dashboard.section.footer.opts or {}
				dashboard.section.footer.opts.hl = "DashboardFooter"

				pcall(vim.cmd.AlphaRedraw)
			end,
		})

		dashboard.opts.opts.noautocmd = true
		dashboard.opts.opts.redraw_on_resize = false

		alpha.setup(dashboard.opts)

		local group = vim.api.nvim_create_augroup("AlphaReopenLastBuffer", { clear = true })

		vim.api.nvim_create_autocmd("VimLeavePre", {
			group = group,
			callback = function()
				dashboard_utils.exiting = true
			end,
		})

		vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
			group = group,
			callback = function(args)
				local buf = args.buf
				if not vim.api.nvim_buf_is_valid(buf) then
					return
				end

				local ft = vim.bo[buf].filetype
				if ft == "neo-tree" or ft == "neo-tree-popup" or ft == "alpha" then
					return
				end

				vim.schedule(function()
					pcall(function()
						dashboard_utils.open_alpha_if_needed()
					end)
				end)
			end,
		})

		vim.api.nvim_create_autocmd("VimResized", {
			group = group,
			callback = function()
				vim.schedule(function()
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local buf = vim.api.nvim_win_get_buf(win)

						if vim.bo[buf].filetype == "alpha" then
							local current_win = vim.api.nvim_get_current_win()

							vim.api.nvim_set_current_win(win)
							pcall(vim.cmd.AlphaRedraw)
							vim.api.nvim_set_current_win(current_win)

							break
						end
					end
				end)
			end,
		})
	end,
}
