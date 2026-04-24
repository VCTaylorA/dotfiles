return {
   "morhetz/gruvbox", -- gruvbox color scheme plugin
   priority = 1000,
   config = function()
     -- Set options for gruvbox
     vim.g.gruvbox_contrast_dark = "hard" -- Set contrast level (options: "soft", "medium", "hard")
     vim.g.gruvbox_italic = 1 -- Enable italics
     vim.g.gruvbox_bold = 1 -- Enable bold text
 
     -- Set the color scheme
     vim.cmd("colorscheme gruvbox")
 
     -- Optional: Set the airline theme
     vim.g.airline_theme = "gruvbox"
   end,
 }