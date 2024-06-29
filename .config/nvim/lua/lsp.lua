-- ============================================================================
-- lsp.lua
--
-- LSP Configuration Helper.
--
-- ### Quick setup:
--
-- If the command to start the lsp server has no arguments and you wish to
-- use the the default settings, call `setup` with the name of the server.
--
-- Example:
--
--   require("lsp").setup("clangd")
--
--
-- ### Full setup:
--
-- Configuring the lsp settings is exactly like configuring with
-- `vim.lsp.start`, except with some default values. See
-- `:help vim.lsp.start()` and `:help vim.lsp.start_client()`.
--
-- If `name` is not set, it will default to the name of the lsp server
-- executable, `cmd[1]`.
--
-- `root_pat` can be used instead of `root_dir` to set the project root
-- directory. Set `root_pat` to a list of files that are searched upward for,
-- marking the project root directory. The following are equivalent:
--
--   root_pat = {".git"}
--   root_dir = vim.fs.dirname(vim.fs.find({".git"}, {upward = true})[1])
--
-- The default `root_pat` is `{".git", "setup.cfg"}`.
--
-- Example:
--
--   require("lsp").setup {
--     name = "lua-language-server",
--     cmd = {"lua-language-server"},
--     root_pat = {".git"}
--     settings = {
--       Lua = {
--         runtime = {
--           version = "LuaJIT",
--         },
--         diagnostics = {
--           globals = {"vim"}, -- Recognize the `vim` global.
--         },
--         workspace = {
--           library = vim.api.nvim_get_runtime_file("", true),
--         },
--         telemetry = {
--           enable = false,
--         },
--       },
--     },
--   }
--
-- ============================================================================

local M = {}

local defaults = {
  root_pat = {".git", "setup.cfg"},
}

local function is_valid_cmd(cmd)
  return vim.fn.executable(cmd[1]) == 1
end

local function root_dir(pat)
  return vim.fs.dirname(vim.fs.find(pat, {upward = true})[1])
end

function M.setup(lsp_config)
  if type(lsp_config) == "string" then
    -- If `lsp_config` is just the command, convert to table.
    lsp_config = {cmd = {lsp_config}}
  end

  if not lsp_config or not is_valid_cmd(lsp_config.cmd) then
    return
  end

  if lsp_config.root_pat then
    -- Search for directory containing `root_pat` pattern and set `root_dir`.
    lsp_config.root_dir = root_dir(lsp_config.root_pat)
  elseif not lsp_config.root_dir then
    -- `root_pat` and `root_dir` not set, use default.
    lsp_config.root_dir = root_dir(defaults.root_pat)
  end

  if not lsp_config.name then
    -- If `name` not explictly set, use executable name.
    lsp_config.name = lsp_config.cmd[1]
  end

  vim.lsp.start(lsp_config)
end

return M
