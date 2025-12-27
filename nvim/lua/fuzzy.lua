vim.opt.path = { ".", "**" }
vim.opt.wildignore:append({
  "*.bmp", "*.gif", "*.ico", "*.jpg", "*.png",
  "*.pdf", "*.ps", ".git/*", "**/node_modules/*",
  "*.pyc", "*.ipynb", ".ipynb_checkpoints/*"
})
