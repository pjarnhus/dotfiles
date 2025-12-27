--Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.textwidth = 88
vim.opt.expandtab = true
vim.opt.autoindent = true

--Numbering
vim.opt.number = true
vim.opt.relativenumber = true

--Statusline
vim.opt.ruler = false
vim.opt.laststatus = 1
vim.opt.fillchars:append({ stl = "⎯", stlnc = "⎯" })
vim.opt.colorcolumn = table.concat(vim.fn.range(88, 999), ",")

vim.api.nvim_set_hl(0, "VertSplit", {})
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#ff0000"})
vim.api.nvim_set_hl(0, "StatusLineNC", {})

vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

