local quotes = require("quotes")

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
  {
    "folke/zen-mode.nvim",
    dependencies = {
      "folke/which-key.nvim",
    },
    config = function()
      require("zen-mode").setup({
        window = {
          height = 30,
        },
        options = {
          signcolumn = "no", -- disable signcolumn
          number = false, -- disable number column
          relativenumber = false, -- disable relative numbers
          cursorline = false, -- disable cursorline
          cursorcolumn = false, -- disable cursor column
          foldcolumn = "0", -- disable fold column
          list = false, -- disable whitespace characters
        },
        plugins = {
          alacritty = {
            enabled = true,
            font = "15",
          },
        },
        on_open = function()
          vim.cmd([[set wrap linebreak nonumber norelativenumber]])
        end,
      })
      local wc = require("which-key")
      local zen_mode = require("zen-mode")
      wc.register({
        z = { zen_mode.toggle, "Toggle zen mode" },
      }, { prefix = "<leader>" })
    end,
  },
  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    config = function()
      local db = require("dashboard")
      db.setup({
        theme = "hyper",
        config = {
          week_header = {
            enable = true,
          },
          shortcut = {
            { icon = " ", desc = "Update packages", group = "@property", action = "Lazy update", key = "u" },
          },
          project = { enable = false },
          footer = {
            "",
            quotes.get_quote(),
          },
        },
      })
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },
}
