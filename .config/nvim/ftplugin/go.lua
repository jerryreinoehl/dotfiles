vim.lsp.start({
  name = "gopls",
  cmd = {"gopls"},
  root_dir = vim.fs.dirname(vim.fs.find({".git"}, {upward = true})[1]),
})
