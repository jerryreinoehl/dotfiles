vim.fn.matchadd("yamlBool", [[\v\c^[^"]+\zsno\ze\s*(#|$)]])
vim.fn.matchadd("yamlBool", [[\v\c^[^"]+\zsyes\ze\s*(#|$)]])
