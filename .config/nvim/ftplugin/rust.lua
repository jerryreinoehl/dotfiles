require("lsp").setup {
  cmd = {"rust-analyzer"},
  filetypes = {"rust"},
  root_pat = {".git", "Cargo.toml", "rust-project.json"},
}
