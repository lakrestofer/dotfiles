-- keymapr
local opts = {noremap = true, silent = true}
local term_opts = {silent = true}
local keymap = vim.api.nvim_set_keymap
keymap("", "<Space>", "<Nop>", opts)

local rebind_map = {
  h = "n",
  j = "e",
  k = "i",
  l = "o"
}

local modes = {'n', "o", "v"}

-- swap hjkl for neio since we use the colemakdh layout
for k,v in pairs(rebind_map) do
  for _,m in ipairs(modes) do
    keymap(m, k, v, opts)
    keymap(m, v, k, opts)
    keymap(m, string.upper(k), string.upper(v), opts)
    keymap(m, string.upper(v), string.upper(k), opts)
  end
end

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
