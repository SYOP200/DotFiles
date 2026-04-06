local M = {}

local default_scheme = "catppuccin-mocha"
local state_file = vim.fn.stdpath("state") .. "/syop200-colorscheme.txt"

M._applying = false

local function read_scheme()
  local ok, lines = pcall(vim.fn.readfile, state_file)
  if not ok or not lines or not lines[1] or lines[1] == "" then
    return default_scheme
  end
  return vim.trim(lines[1])
end

local function write_scheme(name)
  if not name or name == "" then
    return
  end
  pcall(vim.fn.writefile, { name }, state_file)
end

local function normalize_scheme(name)
  if not name or name == "" then
    return default_scheme
  end
  if name == "catppuccin" then
    return default_scheme
  end
  return name
end

local function is_available(name)
  local schemes = vim.fn.getcompletion("", "color")
  return vim.tbl_contains(schemes, name)
end

function M.get()
  return normalize_scheme(read_scheme())
end

function M.persist(name)
  write_scheme(name)
end

function M.apply(name)
  local scheme = normalize_scheme(name or M.get())
  if not is_available(scheme) then
    scheme = default_scheme
  end
  M._applying = true
  local ok = pcall(vim.cmd.colorscheme, scheme)
  M._applying = false

  if ok then
    write_scheme(scheme)
    return true
  end

  if scheme ~= default_scheme then
    M._applying = true
    pcall(vim.cmd.colorscheme, default_scheme)
    M._applying = false
    write_scheme(default_scheme)
  end

  return false
end

function M.select()
  local schemes = vim.fn.getcompletion("", "color")
  schemes = vim.tbl_filter(function(name)
    return name ~= "catppuccin"
  end, schemes)
  table.sort(schemes)

  vim.ui.select(schemes, {
    prompt = "Set theme",
    format_item = function(item)
      return item
    end,
  }, function(choice)
    if choice then
      local ok = M.apply(choice)
      if not ok then
        vim.notify("Failed to set colorscheme: " .. choice, vim.log.levels.ERROR)
      end
    end
  end)
end

function M.setup()
  local group = vim.api.nvim_create_augroup("syop200_colorscheme", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      if M._applying then
        return
      end
      local name = vim.g.colors_name
      if name and name ~= "" then
        write_scheme(normalize_scheme(name))
      end
    end,
  })
end

return M
