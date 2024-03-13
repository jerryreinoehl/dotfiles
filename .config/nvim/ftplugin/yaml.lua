-- Color `yes` and `no` as booleans.
vim.fn.matchadd("yamlBool", [[\v\c^[^"]+\zs(yes|no)\ze\s*(#|$)]])
