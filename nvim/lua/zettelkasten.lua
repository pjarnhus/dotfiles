-- Source Zettelkasten vimscript, if needed
-- This is kept as a vimscript as the lua vim.ui.input does not support custom
-- completion
local zettelkasten_dir = vim.fn.expand("~/zettelkasten/content")

local zettelkasten_config = vim.fn.stdpath("config") .. "/zettelkasten.vim"

vim.api.nvim_create_autocmd({"BufRead"}, {
    pattern = zettelkasten_dir .. "/**/*.md",
    callback = function()
        vim.cmd("source " .. zettelkasten_config)
    end,
    desc = "Source zettelkasten linking for markdown files in zettelkasten directory",
})

