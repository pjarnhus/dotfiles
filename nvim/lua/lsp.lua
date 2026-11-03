vim.lsp.config('basedpyright', {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'uv.lock', 'pyproject.toml', '.git' },
  -- Neovim copies `config.settings` into the client *before* `before_init` runs
  -- (see vim/lsp/client.lua: Client:new copies settings, before_init runs later).
  -- Therefore `before_init` cannot set per-project settings: the mutation never
  -- reaches the client. The working point is `on_init`: after the server is
  -- initialized, we update `client.settings` and send the settings update
  -- ourselves via `workspace/didChangeConfiguration` (basedpyright re-reads its
  -- configuration on this notification).
  on_init = function(client)
    -- When the root comes from `root_markers`, Neovim builds workspace folders
    -- as `{ uri = vim.uri_from_fname(s), name = s }`: `name` is already a plain
    -- path, no `vim.uri_to_fname` conversion needed (URI conversion errors otherwise).
    local folder = client.workspace_folders and client.workspace_folders[1]
    if not folder then
      return
    end
    local root = vim.fs.root(folder.name, { 'uv.lock', 'pyproject.toml' })
    if not root then
      return
    end
    -- Resolve the interpreter for this project (uv-managed venv), synchronously.
    -- NOTE: `uv python find` walks upwards from its cwd to find the project,
    -- so we pass the root via cwd. Passing the directory as an argument instead
    -- searches for interpreters *inside* that directory and fails.
    local out = vim.system({ 'uv', 'python', 'find' }, { cwd = root }):wait()
    if out.code ~= 0 then
      return
    end
    client.settings = vim.tbl_deep_extend('force', client.settings, {
      python = { pythonPath = vim.fn.trim(out.stdout) },
    })
    client:notify('workspace/didChangeConfiguration', { settings = client.settings })
  end,
})

-- Cache of ruff availability per project root.
local ruff_roots = {}

vim.lsp.config('ruff', {
  cmd = { 'uv', 'run', 'ruff', 'server' },
  filetypes = { 'python' },
  -- A `root_dir` function can decide per buffer whether to activate the client.
  -- If it never calls `on_dir`, Neovim skips the client for that buffer
  -- (documented in runtime LSP docs: "a root_dir() function can dynamically
  -- decide per-buffer whether to activate (or skip) LSP"). We use this so ruff
  -- only starts in projects where `uv run` can resolve ruff (dev dependency).
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, { 'uv.lock', 'pyproject.toml' })
    if not root then
      return -- not a uv project: never attach
    end
    local has_ruff = ruff_roots[root]
    if has_ruff == nil then
      -- Probe once per project root and cache; `--version` is cheap and
      -- synchronously confirms that `uv run ruff` resolves in this project.
      local out = vim.system({ 'uv', 'run', 'ruff', '--version' }, { cwd = root }):wait()
      has_ruff = out.code == 0
      ruff_roots[root] = has_ruff
    end
    if has_ruff then
      on_dir(root)
    end
  end,
})

vim.lsp.enable({ 'basedpyright', 'ruff' })
