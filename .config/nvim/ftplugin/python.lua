require("lsp").setup {
  name = "pylsp",
  cmd = {"pylsp"},
  root_pat = {
    ".git",
    "pyproject.toml",
    "setup.cfg",
    "tox.ini",
  }
}

vim.keymap.set("n", "<leader>f", function()
  os.execute("black " .. vim.api.nvim_buf_get_name(0))
  vim.cmd.edit()
end)
