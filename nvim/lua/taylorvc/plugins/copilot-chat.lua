return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    init = function()
      vim.g.copilot_suggestions_enabled = false

      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("TaylorCopilotSuggestions", { clear = true }),
        callback = function(args)
          vim.b[args.buf].copilot_suggestion_auto_trigger = vim.g.copilot_suggestions_enabled
        end,
      })
    end,
    keys = {
      {
        "<leader>cs",
        function()
          local enabled = not vim.g.copilot_suggestions_enabled
          vim.g.copilot_suggestions_enabled = enabled

          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) then
              vim.b[buf].copilot_suggestion_auto_trigger = enabled
            end
          end

          if not enabled then
            require("copilot.suggestion").dismiss()
          end

          vim.notify("Copilot autocomplete " .. (enabled and "enabled" or "disabled"))
        end,
        desc = "Copilot Suggestions Global Toggle",
      },
    },
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
      },
      panel = { enabled = false },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatClose",
      "CopilotChatToggle",
      "CopilotChatReset",
      "CopilotChatStop",
      "CopilotChatModels",
      "CopilotChatPrompts",
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChatToggle<CR>", desc = "Copilot Chat Toggle" },
      { "<leader>ce", "<cmd>CopilotChatExplain<CR>", desc = "Copilot Chat Explain" },
      { "<leader>cr", "<cmd>CopilotChatReview<CR>", desc = "Copilot Chat Review" },
      { "<leader>cv", ":CopilotChat<CR>", mode = "v", desc = "Copilot Chat with Visual Selection" },
      { "<leader>cf", ":CopilotChat file<CR>", desc = "Copilot Chat with Current File" },
    },
    opts = {
      model = "gpt-4.1",
    },
  },
}
