vim.lsp.start({
  name = "texlab",
  cmd = {"texlab"},
  root_dir = vim.fs.dirname(vim.fs.find({".git"}, {upward = true})[1]),
})
