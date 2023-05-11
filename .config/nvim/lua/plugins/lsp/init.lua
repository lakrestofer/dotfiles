return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "williamboman/mason.nvim",
        build = ":MasonUpdate", -- :MasonUpdate updates registry contents
      },
      {
        "williamboman/mason-lspconfig.nvim",
      },
      {
        "folke/neodev.nvim",
        opts = { experimental = { pathStrict = true } },
      },
      {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
      },
      {
        "folke/which-key.nvim",
      },
    },
    config = function()
      require("neodev").setup({})
      require("mason").setup()
      require("mason-lspconfig").setup({})
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,
      })
      require("lspconfig").lua_ls.setup({})
      -- we setup formaters
      local null_ls = require("null-ls")
      -- autoformat
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.diagnostics.eslint,
          --[[
          null_ls.builtins.completion.spell.with({
            filetypes = { "markdown" },
          }),
          null_ls.builtins.diagnostics.cspell.with({
            filetypes = { "markdown" },
          }),
          null_ls.builtins.code_actions.cspell.with({
            filetypes = { "markdown" },
          }),
          --]]
          --null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.formatting.rustfmt,
          null_ls.builtins.formatting.rustywind,
        },
      })
      -- now we do some mappings
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Goto prev diagnostic" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Goto next diagnostic" })
      local wc = require("which-key")
      local builtin = require("telescope.builtin")
      wc.register({
        l = {
          name = "LSP",
          M = { "<cmd>Mason<cr>", "Mason" },
          i = { "<cmd>LspInfo<cr>", "LspInfo" },
        },
      }, { prefix = "<leader>" })

      wc.register({
        g = {
          r = { builtin.lsp_references, "goto references" },
          i = { builtin.lsp_implementations, "goto implementations" },
          d = { builtin.lsp_definitions, "goto definitions" },
        },
      })

      -- we will not define some mappings which are only active when lsp is attached
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Declaration" })
          -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer = ev.buf, desc="Definition"})
          -- vim.keymap.set("n", "gr", vim.lsp.buf.references, {buffer = ev.buf, desc="References"})
          -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer = ev.buf, desc="Implementation"})
          vim.keymap.set("n", "<leader>lH", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover" })
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature" })
          vim.keymap.set(
            "n",
            "<leader>wa",
            vim.lsp.buf.add_workspace_folder,
            { buffer = ev.buf, desc = "Add workspace folder" }
          )
          vim.keymap.set(
            "n",
            "<leader>wr",
            vim.lsp.buf.remove_workspace_folder,
            { buffer = ev.buf, desc = "Add workspace folder" }
          )
          vim.keymap.set("n", "<leader>lD", vim.lsp.buf.type_definition, { buffer = ev.buf, desc = "Type definition" })
          vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
          vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
          vim.keymap.set("n", "<leader>lf", function()
            vim.lsp.buf.format({ async = true })
          end, { buffer = ev.buf, desc = "Format" })
        end,
      })
    end,
  },
}
