-- ============================================================================
-- Options
-- ============================================================================

-- Number of spaces that a <Tab> counts for.
vim.opt.tabstop = 4

-- Number of spaces a <Tab> appears to be.
vim.opt.softtabstop = 2

-- Number of spaces to use for each step of (auto)indent.
vim.opt.shiftwidth = 2

-- Use the appropriate number of spaces to insert a <Tab>. To insert a real tab
-- when `expandtab` is on, use CTRL-V<Tab>.
vim.opt.expandtab = true

-- Copy indent from current line when starting a new line.
vim.opt.autoindent = true

-- Write the contents of the file, if it has been modified, on each :next
-- :rewind, :last, :first, :previous, :stop, :suspend, :tag, :!, :make, CTRL-]
-- and CTRL-^ command.
vim.opt.autowrite = true

-- Display line numbers.
vim.opt.number = true

-- Highlight the text line of the cursor with CursorLine `hl-CursorLine`.
vim.opt.cursorline = true

-- When a bracket is inserted, briefly jump to the matching one. The time to
-- show the match can be set with `matchtime`. The `matchpairs` option can be
-- used to specify the characters to show matches for.
vim.opt.showmatch = true

-- Ignore case in search patterns. Also used when searching in the tags file.
vim.opt.ignorecase = true

-- Override the `ignorecase` option if the search pattern contains upper case
-- characters.
vim.opt.smartcase = true

-- When there is a previous search pattern, highlight all its matches. The
-- `hl-Search` highlight group determines the highlighting.
vim.opt.hlsearch = true

-- While typing a search command, show where the pattern, as it was typed so
-- far, matches. You can use CTRL-G and CTRL-T to move to the next or previous
-- match.
vim.opt.incsearch = true

-- Show (partial) command in the last line of the screen.
vim.opt.showcmd = true

-- Enables "enhanced mode" of command-line completion. When user hits <Tab> (or
-- `wildchar`) to invoke completion, the possible matches are shown in a menu
-- just above the command-line, with the first match highlighted. `hl-WildMenu`
-- highlights the current match.
vim.opt.wildmenu = true

-- Set the last window to always have a status line.
vim.opt.laststatus = 2

-- The screen will not be redrawn while executing macros, registers, and other
-- commands that have not been typed.
vim.opt.lazyredraw = true

-- filetype indent on

-- Allow folds.
vim.opt.foldenable = true

-- Folds are formed on lines with equal indent.
vim.opt.foldmethod = "indent"

-- Useful to see the difference between tabs and spaces and for trailing
-- whilespace. Further changed by the `listchars` option.
vim.opt.list = true

-- Strings to use in `list` mode.
vim.opt.listchars = {tab = "| ", trail = "·", precedes = "<", extends = ">"}

-- Time in milliseconds to wait for a mapped sequence to complete.
vim.opt.timeoutlen = 500

-- Splitting a window will put the new window below the current one.
vim.opt.splitbelow = true

-- Splitting a window will put the new window right of the current one.
vim.opt.splitright = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 4

-- Set how automatic formatting is done. See `:help fo-table`.
vim.opt.formatoptions = "tcrqljp"


-- ============================================================================
-- Key Bindings
-- ============================================================================

-- Set <leader> to "\".
vim.g.mapleader = [[\]]

-- Save buffer.
vim.keymap.set("n", "<leader><leader>", ":write<cr>", {desc = "Save buffer"})

-- Run make.
vim.keymap.set("n", "<leader>m", ":!make<cr>", {desc = "make"})

-- Navigate through wrapped lines.
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- "jk" to escape.
vim.keymap.set("i", "jk", "<esc>")


-- ============================================================================
-- Highlight Groups
-- ============================================================================

vim.api.nvim_set_hl(0, "TrailingWhitespace", {ctermfg="red"})
vim.fn.matchadd("TrailingWhitespace", [[\s\+$]])
