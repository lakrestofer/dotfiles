
local opt = vim.opt
-- opt.debug                 = "msg" -- set to "msg" to see all error messages
-- ======= GENERAL SETTINGS =======
opt.timeoutlen     = 500 -- time out time in milliseconds
-- ======= INDENTATION =======
opt.autoindent     = false -- take indent for new line from previous line
opt.copyindent     = false -- make 'autoindent' use existing indent structure
opt.expandtab      = true -- use spaces when <Tab> is inserted
opt.shiftwidth     = 2   -- number of spaces to use for (auto)indent step
opt.tabstop        = 2   -- number of spaces that <Tab> in file uses
-- opt.smarttab      = false -- use 'shiftwidth' when inserting <Tab>

-- ======= NEOVIDE ======
if vim.g.neovide then
  vim.o.guifont = "FiraCode Nerd Font"
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_vfx_mode = "wireframe"
end
-- ======= FILE BEHAVIOUR =======
-- opt.autoread   = false -- autom. read file when changed outside of Vim
-- opt.autowrite     = false -- automatically write file if changed
-- opt.autowriteall  = false -- as 'autowrite', but works with more commands
-- opt.autochdir     = false -- change directory to the file in the current window
opt.confirm        = true -- ask what to do about unsaved/read-only files

-- ======= APPERANCE =======
opt.background     = "dark" -- "dark" or "light", used for highlight colors
-- opt.columns       = 40 -- number of columns in the display
-- opt.colorcolumn   = "80" -- columns to highlight
opt.cmdheight      = 2                 -- number of lines to use for the command-line
-- opt.cursorbind    = false -- move cursor in window as it moves in other windows
opt.cursorcolumn   = false             -- highlight the screen column of the cursor
opt.cursorline     = false              -- highlight the screen line of the cursor
-- opt.highlight     = -- sets highlighting mode for various occasions
opt.number         = true              -- print the line number in front of each line
opt.relativenumber = true              -- show relative line number in front of each line
-- opt.numberwidth   = -- number of columns used for the line number
opt.ruler          = true              -- show cursor line and column in the status line
opt.scrolloff      = 8                 -- minimum nr. of lines above and below cursor
opt.title          = true              -- let Vim set the title of the window
opt.titlestring    = "Neovim is great!" -- string to use for the Vim window title
-- opt.statusline    = -- custom format for the status line
opt.termguicolors  = true
opt.showtabline    = 2 -- tells when the tab pages line is displayed
opt.signcolumn     = "yes" -- when and how to draw the signcolumn

-- ======= MACRO BEHAVIOUR =======
opt.lazyredraw     = false -- don't redraw while executing macros (You want this!)

-- ======= BACKUP/SWAP BEHAVIOUR =======
opt.backup         = false -- keep backup file after overwriting a file
opt.swapfile       = false -- whether to use a swapfile for a buffer

-- ======= BUFFER BEHAVIOUR =======
opt.hidden         = true -- don't unload buffer when it is YXXYabandon|ed

-- ======= Clipboard/Registers =======
--opt.clipboard     = "unnamedplus" -- use the clipboard as the unnamed register

-- ======= CONCEALMENT OPTIONS =======
-- opt.concealcursor = "n" -- whether concealable text is hidden in cursor line
-- opt.conceallevel  = 3 -- whether concealable text is shown or hidden

-- ======= GUI OPTIONS =======
opt.guifont        = "FiraCode Nerd Font" -- GUI: Name(s) of font(s) to be used
-- ======= MOUSE OPTIONS =======
opt.mouse          = "a"                 -- enable the use of mouse clicks
-- ======= SEARCH OPTIONS =======
opt.hlsearch       = true                -- highlight matches with last search pattern
opt.ignorecase     = true                -- ignore case in search patterns
opt.incsearch      = true                -- highlight match while typing search pattern
opt.smartcase      = true                -- no ignore case when pattern has uppercase
opt.wrapscan       = true                -- searches wrap around the end of the file

-- ======= WRAPPING BEHAVIOUR =======
opt.wrap           = false -- long lines wrap and continue on the next line
opt.linebreak      = false -- break line at word boundary

-- opt.previewheight = 14 -- height of the preview window
-- opt.previewwindow = true -- identifies the preview window
opt.pumheight      = 10 -- maximum height of the popup menu

-- ======= SPELLING OPTIONS =======
opt.spell          = false  -- enable spell checking
opt.spelllang      = "en,se" -- language(s) to do spell checking for

opt.splitbelow     = true   -- new window from split is below the current one
opt.splitright     = true   -- new window is put right of the current one
