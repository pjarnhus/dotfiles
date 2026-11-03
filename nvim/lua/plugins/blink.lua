return {
  'saghen/blink.cmp',
  version = '*',
  opts = {
    keymap = {
      preset = 'none',
      ['<Tab>'] = { 'show', 'select_next', 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
    },
    sources = { default = { 'lsp' } },
    completion = {
      trigger = {
        -- never show on its own; only via keymap
        show_on_keyword = false,
        show_on_trigger_character = false,
        show_on_insert_on_trigger_character = false,
        show_on_accept_on_trigger_character = false,
      },
      list = { selection = { preselect = false, auto_insert = false } },
    },
  },
}
