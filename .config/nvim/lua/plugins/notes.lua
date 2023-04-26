
local augroup = vim.api.nvim_create_augroup("ZkNotesFormat", {})
-- we will be using neorg for our notetaking needs
return {
  {
    "mickael-menu/zk-nvim",
    dependencies = {
      "folke/which-key.nvim",
    },
    config = function()
      require("zk").setup({
        picker = "telescope",
        config = {
          --[[
          on_attach = function(_, bufnr)
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
             vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                  local zk = require("zk")
                  zk.index() -- index on save
                end,
            })
          end
          --]]
        }
      })

      local wc = require("which-key")
      local zk = require("zk")
      local cmd = require("zk.commands")
      wc.register({
        n = {
          name = "Notes",
          c = {
            function()
              zk.cd()
            end,
            "Cd into notes dir",
          },
          I = {
            function()
              zk.index()
            end,
            "Index notes directory",
          },
          i = {
            function()
              zk.get("ZkInsertLink")()
            end,
            "Insert link to note",
          },
          o = {
            function()
              cmd.get("ZkNotes")()
            end,
            "Open note",
          },
          n = {
            function()
              local title = vim.fn.input("Title: ")
              if title ~= nil and title ~= "" then
                zk.new({ title = title, date = "today" })
              else
                print("No title was provided. Aborting...")
              end
            end,
            "Create new note",
          },
          b = {
            function()
              cmd.get("ZkBacklinks")()
            end,
            "Open backlinks in note",
          },
          l = {
            function()
              cmd.get("ZkLinks")()
            end,
            "Open links in note",
          },
        },
      }, { prefix = "<leader>" })
      wc.register({
        n = {
          name = "Notes",
          n = {
            function()
              cmd.get("ZkNewFromTitleSelection")({ date = "today" })
            end,
            "New note with title from selection",
          },
          N = {
            function()
              local title = vim.fn.input("Title: ")
              if title ~= nil and title ~= "" then
                cmd.get("ZkNewFromContentSelection")({ title = title, date = "today" })
              else
                print("No title was provided. Aborting...")
              end
            end,
            "New note with content from selection",
          },
        },
        i = {
          function()
            zk.get("ZkInsertLinkAtSelection")()
          end,
          "Insert link to note",
        },
      }, { prefix = "<leader>", mode = "v" })
    end,
  },
}
