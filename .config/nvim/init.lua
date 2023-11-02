-- some setting which we want to enable on startup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- we begin by bootstraping our plugin package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("settings") -- some good default settings
require("remap") -- here we set all the bindings which are independent on nvim

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup("plugins") -- we load all the plugins in the plugins folder
