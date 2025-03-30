require("lsp").setup("gopls")

vim.opt.expandtab = false
vim.opt.shiftwidth = 4

vim.api.nvim_create_autocmd({"BufWritePre"}, {
  callback = function()
    vim.lsp.buf.format()
  end
})
