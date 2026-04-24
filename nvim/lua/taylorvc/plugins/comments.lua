return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    -- import comment plugin safely
    local comment = require("Comment")
    local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

    -- enable comment
    comment.setup({
      -- for commenting tsx, jsx, svelte, html files
      pre_hook = ts_context_commentstring.create_pre_hook(),

      -- Define specific language commenting behaviors
      toggler = {
        -- Set key mappings for toggling comments for different languages
        line = "<leader>c", -- Toggle comment for line
        block = "<leader>bc", -- Toggle comment for block
      },

      opleader = {
        line = "<leader>c", -- Operation leader key for line commenting
        block = "<leader>bc", -- Operation leader key for block commenting
      },

      -- Custom configurations for C, Java, Python, and Clojure
      lang = {
        c = {
          -- Specify how line and block comments should look like for C
          -- C comments are: // for line and /* */ for block
          line = "//",
          block = { "/*", "*/" },
        },
        java = {
          -- Specify how line and block comments should look like for Java
          line = "//",
          block = { "/*", "*/" },
        },
        python = {
          -- Python uses # for line comments
          line = "#",
          block = { "'''", "'''" },  -- Python supports block comments using triple quotes
        },
        clojure = {
          -- Clojure uses ; for line comments
          line = ";",
          block = { "#|", "|#" },  -- Clojure uses #| |# for block comments
        },
      },
    })
  end,
}

