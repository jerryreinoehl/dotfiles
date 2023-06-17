require("lsp").setup {
  cmd = {"haskell-language-server-wrapper", "--lsp"},
  filetypes = {"haskell", "lhaskell", "cabal"},
  root_pat = {".git", "hie.yaml", "stack.yaml", "cabal.project"},
  single_file_support = true,
}
