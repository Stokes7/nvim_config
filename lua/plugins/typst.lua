return {
	"chomosuke/typst-preview.nvim",
	version = "1.*", -- puedes fijar versión si quieres
	ft = "typst", -- carga solo cuando abras archivos .typ
	config = function()
		require("typst-preview").setup({
			debug = false,
			open_cmd = nil,
			port = 0,
			invert_colors = "never",
			follow_cursor = true,
			dependencies_bin = {
				["tinymist"] = nil,
				["websocat"] = nil,
			},
			extra_args = nil,
			get_root = function(path_of_main_file)
				local root = os.getenv("TYPST_ROOT")
				if root then
					return root
				end
				return vim.fn.fnamemodify(path_of_main_file, ":p:h")
			end,
			get_main_file = function(path_of_buffer)
				return path_of_buffer
			end,
		})
	end,
}
