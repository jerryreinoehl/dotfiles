-- ============================================================================
-- Colors
-- ============================================================================

local M = {}

local colors = {
  CursorLine = {ctermbg = "black"},
  CursorLineNr = {ctermfg = "gray"},
  Comment = {ctermfg = "darkgray", italic = true},
  LineNr = {ctermfg = "darkgray"},
}

for name, color in pairs(colors) do
  vim.api.nvim_set_hl(0, name, color)
end

return M
