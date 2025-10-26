vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set relativenumber")

local opt = vim.opt

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register
-- add padding to top
opt.winbar = " "
opt.scrolloff = 8
-- don't highlight search results
opt.hlsearch = false

vim.diagnostic.config({ virtual_lines = { current_line = true }, virtual_text = { current_line = false } })
