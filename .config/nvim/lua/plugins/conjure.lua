return {
  "Olical/conjure",
  ft = { "clojure", "fennel", "janet", "racket", "scheme", "lisp" },
  dependencies = {
    "PaterJason/cmp-conjure",
  },
  init = function()
    vim.g["conjure#mapping#doc_word"] = "K"
    vim.g["conjure#log#hud#enabled"] = true
    vim.g["conjure#log#hud#width"] = 0.42
    vim.g["conjure#log#hud#anchor"] = "SE"
    vim.g["conjure#log#botright"] = true
    vim.g["conjure#extract#tree_sitter#enabled"] = true
    vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = true
  end,
}
