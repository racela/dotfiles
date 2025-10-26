vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- search and replace
keymap.set("n", "<leader>r", ":%s//g<left><left>", { desc = "Search and replace shortcut" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set('n', '<leader>pa', 'ggVGp',         { desc = "select all and paste" })
keymap.set('n', '<leader>sa', 'ggVG',          { desc = "select all" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "scroll up and center" })
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "scroll down and center" })

keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selected line down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selected line up" })

keymap.set("n", "n", "nzzzv", { desc = "keep cursor centered when searching forwards" })
keymap.set("n", "N", "Nzzzv", { desc = "keep cursor centered when searching backwards" })

keymap.set("x", "p", "\"_dP", { desc = "don't overwrite text when pasting on top" })

keymap.set("n", "<leader>d", "\"_d", { desc = "don't copy text when deleting" })
keymap.set("v", "<leader>d", "\"_d", { desc = "don't copy text when deleting" })

vim.keymap.set("n", "<leader>w", ":w<CR>",    { desc = "Quick save" })
