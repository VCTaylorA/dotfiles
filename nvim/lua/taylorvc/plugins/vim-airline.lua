return {
    "vim-airline/vim-airline", -- vim-airline plugin
    dependencies = { "vim-airline/vim-airline-themes" }, -- optional themes for vim-airline
    config = function()
      -- Enable powerline fonts if supported
      --vim.g.airline_powerline_fonts = 1
  
      -- Set the airlines theme to match your colorscheme
      vim.g.airline_theme = "gruvbox"

        -- Customize the Z section to only show row and column without extra symbols
        vim.g.airline_section_z = "%l:%c" -- %l is the current line, %c is the current column

    end,
  }
