return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- seed once
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

		local function change_header()
			local new_header = load_random_header()
			if new_header then
				dashboard.config.layout[2] = new_header
				pcall(vim.cmd.AlphaRedraw)
			else
				vim.notify("Alpha: no header to load.", vim.log.levels.WARN)
			end
		end

		-- pick a header (with fallback)
		local header = load_random_header() or dashboard.section.header

		-- buttons (kept the useful ones; removed Obsidian)
		dashboard.section.buttons.val = {
			dashboard.button("w", "🖌️ Change header image", function()
				change_header()
			end),
			dashboard.button("c", "🛠️ Settings", ":e $HOME/.config/nvim/init.lua<CR>"),
			dashboard.button("r", "⌛ Recent files", ":Telescope oldfiles<CR>"),
			dashboard.button("t", "🖮  Practice typing with Typr", ":Typr<CR>"),
			dashboard.button("u", "🔌 Update plugins", "<cmd>Lazy update<CR>"),
		}

		dashboard.config.layout = {
			{ type = "padding", val = 3 },
			header,
			{ type = "padding", val = 2 },
			{
				type = "group",
				val = {
					{ type = "group", val = dashboard.section.buttons.val, opts = { spacing = 1 } },
				},
				opts = { layout = "horizontal" },
			},
			{ type = "padding", val = 2 },
			dashboard.section.footer,
		}

		-- footer stats (fix: set footer hl, not header)
		vim.api.nvim_create_autocmd("User", {
			pattern = "VimStarted",
			once = true,
			callback = function()
				local stats = require("lazy").stats()
				local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
				dashboard.section.footer.val =
					{ " ", " ", " ", " Loaded " .. stats.count .. " plugins  in " .. ms .. " ms " }
				dashboard.section.footer.opts = dashboard.section.footer.opts or {}
				dashboard.section.footer.opts.hl = "DashboardFooter"
				pcall(vim.cmd.AlphaRedraw)
			end,
		})

		dashboard.opts.opts.noautocmd = true
		alpha.setup(dashboard.opts)
	end,
}
