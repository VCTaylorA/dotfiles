return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" }, -- Load the plugin only for Markdown files
  config = function()
    require("render-markdown").setup({
      -- Optional: Customize the setup
      theme = "light", -- Choose between "light" or "dark" theme
      auto_open = true, -- Automatically open the rendered Markdown in the browser
      browser = "firefox", -- Specify the browser to use (e.g., "firefox", "chrome")
    })

    -- Keybinding to render Markdown
    vim.keymap.set("n", "<leader>mr", "<cmd>RenderMarkdown<CR>", { desc = "Render Markdown" })
  end,
}