local servers = {
  "biome", --{ "astro", "css", "graphql", "html", "javascript", "javascriptreact", "json", "jsonc", "svelte", "typescript", "typescriptreact", "vue" }
  "html",
  "cssls", --{ "css", "scss", "less" }
  "tailwindcss", --{ "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure", "django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "gohtmltmpl", "haml", "handlebars", "hbs", "html", "htmlangular", "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte", "templ" }
  "pyright", --python
  --"basedpyright", python static type checker 
  "jdtls", --java
  "clangd", --{ "c", "cpp", "objc", "objcpp", "cuda" }
  "clojure_lsp", --clojure..
}

return {
  "neovim/nvim-lspconfig",
  servers = servers,
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
      end,
    })

    -- Show all diagnostics in a Telescope popup !!
    vim.keymap.set("n", "<leader>dp", "<cmd>Telescope diagnostics<CR>", { desc = "Show all diagnostics (Problems)" })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      vim.diagnostic.config({--added by copilot
        signs = {
          [type] = { text = icon, texthl = "DiagnosticSign" .. type },
        },
      })
    end

    -- Enable inline diagnostics (virtual text)
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●", -- Could be '●', '▎', 'x'
        spacing = 4, -- Space between diagnostic and text
      },
      signs = true, -- Show signs in the gutter
      underline = true, -- Underline the text with issues
      update_in_insert = false, -- Update diagnostics in insert mode
      severity_sort = true, -- Sort diagnostics by severity
    })

    for _, server_name in ipairs(servers) do
      vim.lsp.config(server_name, {
        capabilities = capabilities,
      })
      vim.lsp.enable(server_name)
    end
  end,
}

