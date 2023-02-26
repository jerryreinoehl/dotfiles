vim.lsp.start({
  name = "pylsp",
  cmd = {"pylsp"},
  root_dir = vim.fs.dirname(vim.fs.find({".git"}, {upward = true})[1]),
})
