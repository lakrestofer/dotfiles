return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/which-key.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope-file-browser.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      local tele = require("telescope")
      -- local actions = require("telescope.actions")
      -- local fw_actions = require "telescope".extensions.file_browser.actions
      tele.setup({
        defaults = {
          mappings = {
            i = {
              -- ["<esc>"] = actions.close, -- make esc close picker instantly
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          file_browser = {
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            mappings = {
              -- we keep the defaults
            },
          },
        },
      })
      tele.load_extension("fzf")
      tele.load_extension("file_browser")

      -- we register some bindings
      local wc = require("which-key")
      local builtin = require("telescope.builtin")
      wc.register({
        ["<leader>"] = {
          b = { builtin.buffers, "Buffers" },
          f = { builtin.find_files, "Files" },
          F = { tele.extensions.file_browser.file_browser, "File browser"},
          h = { builtin.help_tags, "Help" },
          c = { builtin.colorscheme, "Colorscheme" },
          g = { builtin.live_grep, "Live grep" },
          G = {
            name = "Git",
            c = { builtin.git_commits, "Commits" },
            s = { builtin.git_status, "Status" },
          },
        },
      })
    end,
  },
}
