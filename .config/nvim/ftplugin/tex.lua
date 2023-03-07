require("lsp").setup {
  cmd = {"texlab"},
  single_file_support = true,
  settings = {
    texlab = {
      rootDirectory = nil,
      build = {
        executable = "latexmk",
        args = {"-pdf", "-interaction=nonstopmode", "-synctex=1", "%f"},
        onSave = true,
        forwardSearchAfter = false,
      },
      auxDirectory = ".",
      forwardSearch = {
        executable = nil,
        args = {},
      },
      chktex = {
        onOpenAndSave = true,
        onEdit = true,
      },
      diagnosticDelay = 300,
      latexFormatter = "latexindent",
      latexindent = {
        ["local"] = nil,
        modifyLineBreaks = false,
      },
      bibtexFormatter = "texlab",
      formatterLineLength = 80,
    },
  },
}

vim.bo.makeprg = "latexmk -pdf -interaction=nonstopmode -synctex=1 %"

vim.keymap.set("n", "<leader>z", function()
  local cmd = {"zathura", "--fork", vim.fn.expand("%:r") .. ".pdf"}
  os.execute(table.concat(cmd, " "))
end, {buffer = true, desc = "Open PDF reader"})
