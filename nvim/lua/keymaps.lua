vim.g.mapleader = "æ"

--Open file with fuzzy find
vim.keymap.set("n", "<leader>o", ":find *")

--Insert linebreak in normal mode
vim.keymap.set("n", "<leader>j", "i<CR><ESC>")

--List buffers and prepare for switching
vim.keymap.set("n", "<leader>b", ":ls<CR>:buffer<space>")

--Window navigation
vim.keymap.set("n", "<C-H>", "<C-W>h")
vim.keymap.set("n", "<C-J>", "<C-W>j")
vim.keymap.set("n", "<C-K>", "<C-W>k")
vim.keymap.set("n", "<C-L>", "<C-W>l")

