return {
    'olimorris/codecompanion.nvim',
    version='^19.0.0',
    opts = {
        interactions = {
            chat = {
                adapter = "openai",
            },
        },
        display = {
            chat = {
                window = {
                    layout = 'vertical',
                    full_hight = true,
                    position = 'right',
                    width = 0.4,
                },
            },
        },
        rules = {
            default = {
                description = "Common system prompts for all projects",
                files = {
                    "AGENT.md",
                    "AGENTS.md"
                },
                is_preset = true,
            },
            opts = {
                chat = {
                    autoload = "default",
                    enabled = true,
                },
            },
        },
    },
    dependencies = {
        { 'nvim-lua/plenary.nvim', branch='master' },
        'nvim-treesitter/nvim-treesitter',
    },
}
