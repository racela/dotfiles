vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

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

vim.keymap.set("n", "<leader>w", ":w<CR>",    { desc = "Quick save" })

