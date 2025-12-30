return {
    "tmux-pipe",
    dir = "~/tmux-pipe/",
    config = function()
        require('tmux-pipe').setup({
           line = "<leader><leader>",
           selection = "<leader><leader>",
        })
    end,
}
