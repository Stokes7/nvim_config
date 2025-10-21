return {
  "olimorris/onedarkpro.nvim",
  priority = 1000,
  config = function()
    local transparency_enabled = true

    require("onedarkpro").setup({
      options = {
        transparency = transparency_enabled,
      },
      colors = {
        red = "#FF4D4D",
      },
    })

    vim.cmd("colorscheme onedark_dark")

    -- Función para alternar transparencia
    local toggle_transparency = function()
      transparency_enabled = not transparency_enabled
      require("onedarkpro").setup({
        options = {
          transparency = transparency_enabled,
        },
        colors = {
          red = "#FF4D4D",
        },
      })
      vim.cmd("colorscheme onedark_dark")
    end

    vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true })
  end
}

