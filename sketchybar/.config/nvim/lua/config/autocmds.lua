local ui = vim.api.nvim_create_augroup("syop200_ui", { clear = true })
local normal_guicursor = vim.o.guicursor
local hidden_guicursor = "a:block-CursorHidden/lCursorHidden-blinkwait0-blinkon0-blinkoff0"
local hidden_iterm_cursor = "#24273a"

local function terminal_send(sequence)
  if vim.fn.has("nvim-0.10") == 1 and vim.api.nvim_ui_send then
    vim.api.nvim_ui_send(sequence)
  else
    vim.fn.chansend(vim.v.stderr, sequence)
  end
end

local function terminal_cursor(visible)
  terminal_send(visible and "\27[?25h" or "\27[?25l")
end

local function iterm2_cursor(visible)
  if vim.env.TERM_PROGRAM ~= "iTerm.app" then
    return
  end
  if visible then
    terminal_send("\27]112\7")
    return
  end
  terminal_send("\27]12;" .. hidden_iterm_cursor .. "\7")
end

local function set_cursor_visibility(visible)
  vim.opt.guicursor = visible and normal_guicursor or hidden_guicursor
  terminal_cursor(visible)
  iterm2_cursor(visible)
end

local function is_real_editable_file(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end
  if vim.bo[buf].filetype == "dashboard" then
    return false
  end
  if vim.bo[buf].buftype ~= "" then
    return false
  end
  if not vim.bo[buf].modifiable then
    return false
  end
  return true
end

local function refresh_cursor_visibility()
  local buf = vim.api.nvim_get_current_buf()
  local visible = is_real_editable_file(buf)
  set_cursor_visibility(visible)
end

_G.SYOP200_refresh_cursor_visibility = refresh_cursor_visibility
_G.SYOP200_set_cursor_visibility = set_cursor_visibility

local function dashboard_visible_buffers()
  local buffers = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "dashboard" then
      buffers[buf] = true
    end
  end
  return vim.tbl_keys(buffers)
end

local function floating_window_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative and config.relative ~= "" then
      return true
    end
  end
  return false
end

local function highlight_dashboard(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  local status = vim.b[buf].syop200_dashboard_status
  local header_done = false
  local ns = vim.api.nvim_create_namespace("syop200_dashboard_hl")
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  for line_nr, line in ipairs(lines) do
    if not header_done and line ~= "" then
      if status and line:find(status, 1, true) then
        vim.api.nvim_buf_add_highlight(buf, ns, "DashboardFooter", line_nr - 1, 0, -1)
      elseif line:find("%[[%w]%]") then
        header_done = true
        vim.api.nvim_buf_add_highlight(buf, ns, "DashboardCenter", line_nr - 1, 0, -1)
      else
        vim.api.nvim_buf_add_highlight(buf, ns, "DashboardHeader", line_nr - 1, 0, -1)
      end
    elseif line:find("%[[%w]%]") then
      vim.api.nvim_buf_add_highlight(buf, ns, "DashboardCenter", line_nr - 1, 0, -1)
    end

    if status and line:find(status, 1, true) then
      vim.api.nvim_buf_add_highlight(buf, ns, "DashboardFooter", line_nr - 1, 0, -1)
    end
    local start_col = 1
    while true do
      local s, e = line:find("%[[%w]%]", start_col)
      if not s then
        break
      end
      vim.api.nvim_buf_add_highlight(buf, ns, "DashboardShortcut", line_nr - 1, s - 1, e)
      start_col = e + 1
    end
  end
end

local function set_dashboard_hidden(buf, hidden)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  if hidden then
    if vim.b[buf].syop200_dashboard_hidden then
      return
    end
    vim.b[buf].syop200_dashboard_saved_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local blank = {}
    for _ = 1, math.max(#vim.b[buf].syop200_dashboard_saved_lines, 1) do
      table.insert(blank, "")
    end
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, blank)
    vim.bo[buf].modifiable = false
    vim.bo[buf].modified = false
    vim.b[buf].syop200_dashboard_hidden = true
    return
  end

  if not vim.b[buf].syop200_dashboard_hidden then
    return
  end
  local saved = vim.b[buf].syop200_dashboard_saved_lines or {}
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, saved)
  vim.bo[buf].modifiable = false
  vim.bo[buf].modified = false
  vim.b[buf].syop200_dashboard_hidden = false
  highlight_dashboard(buf)
end

local function refresh_dashboard_visibility()
  local hide = floating_window_open()
  for _, buf in ipairs(dashboard_visible_buffers()) do
    set_dashboard_hidden(buf, hide)
  end
end

local function apply_transparency()
  local ok, palette = pcall(require, "catppuccin.palettes")
  if not ok then
    return
  end

  local colors = palette.get_palette("mocha")
  local set = vim.api.nvim_set_hl

  for _, group in ipairs({
    "Normal",
    "NormalNC",
    "SignColumn",
    "EndOfBuffer",
    "StatusLine",
    "StatusLineNC",
    "TabLineFill",
    "FoldColumn",
    "WinBar",
    "WinBarNC",
    "NeoTreeNormal",
    "NeoTreeNormalNC",
  }) do
    set(0, group, { bg = "NONE" })
  end

  set(0, "CursorLine", { bg = "NONE" })
  set(0, "CursorLineNr", { fg = colors.peach, bold = true })
  set(0, "Visual", { bg = colors.surface1 })
  set(0, "Search", { fg = colors.base, bg = colors.peach })
  set(0, "IncSearch", { fg = colors.base, bg = colors.peach })
  set(0, "NormalFloat", { bg = colors.mantle })
  set(0, "FloatBorder", { bg = colors.mantle, fg = colors.surface2 })
  set(0, "FloatTitle", { bg = colors.mantle, fg = colors.peach, bold = true })
  set(0, "DashboardHeader", { fg = colors.peach, bold = true })
  set(0, "DashboardIcon", { fg = colors.peach })
  set(0, "DashboardCenter", { fg = colors.subtext1 })
  set(0, "DashboardShortcut", { fg = colors.peach, bold = true })
  set(0, "DashboardFooter", { fg = colors.overlay1, italic = true })
  set(0, "CursorHidden", { bg = colors.base, blend = 100 })
  set(0, "lCursorHidden", { bg = colors.base, blend = 100 })
  set(0, "TelescopeNormal", { bg = colors.mantle })
  set(0, "TelescopeBorder", { bg = colors.mantle, fg = colors.surface2 })
  set(0, "TelescopeTitle", { bg = colors.mantle, fg = colors.peach, bold = true })
  set(0, "TelescopePromptNormal", { bg = colors.mantle })
  set(0, "TelescopePromptBorder", { bg = colors.mantle, fg = colors.surface2 })
  set(0, "TelescopeResultsNormal", { bg = colors.mantle })
  set(0, "TelescopeResultsBorder", { bg = colors.mantle, fg = colors.surface2 })
  set(0, "TelescopePreviewNormal", { bg = colors.mantle })
  set(0, "TelescopePreviewBorder", { bg = colors.mantle, fg = colors.surface2 })
  set(0, "LazyNormal", { bg = colors.mantle })
  set(0, "MasonNormal", { bg = colors.mantle })
  set(0, "NoiceCmdlinePopup", { bg = colors.mantle })
  set(0, "NoiceCmdlinePopupBorder", { bg = colors.mantle, fg = colors.surface2 })
  set(0, "NoicePopup", { bg = colors.mantle })
  set(0, "NoicePopupBorder", { bg = colors.mantle, fg = colors.surface2 })
  set(0, "NeoTreeDirectoryName", { fg = colors.yellow, bold = true })
  set(0, "NeoTreeDirectoryIcon", { fg = colors.yellow })
  set(0, "NeoTreeFileIcon", { fg = colors.peach })
  set(0, "NeoTreeModified", { fg = colors.peach, italic = true })
  set(0, "NeoTreeGitAdded", { fg = colors.peach })
  set(0, "NeoTreeGitDeleted", { fg = colors.peach })
  set(0, "NeoTreeGitModified", { fg = colors.peach })
  set(0, "NeoTreeGitRenamed", { fg = colors.peach })
  set(0, "NeoTreeGitUntracked", { fg = colors.peach })
  set(0, "NeoTreeGitIgnored", { fg = colors.peach })
  set(0, "NeoTreeGitConflict", { fg = colors.peach, bold = true })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = ui,
  pattern = "catppuccin*",
  callback = apply_transparency,
})

vim.api.nvim_create_autocmd("User", {
  group = ui,
  pattern = "VeryLazy",
  callback = apply_transparency,
})

vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter", "WinEnter", "InsertEnter", "InsertLeave" }, {
  group = ui,
  callback = function()
    vim.schedule(refresh_cursor_visibility)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = ui,
  pattern = "dashboard",
  callback = function(event)
    set_cursor_visibility(false)

    vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "CursorMoved", "CursorMovedI" }, {
      group = ui,
      buffer = event.buf,
      callback = function()
        set_cursor_visibility(false)
      end,
    })
  end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  group = ui,
  callback = function()
    terminal_cursor(true)
  end,
})

vim.api.nvim_create_autocmd("VimResume", {
  group = ui,
  callback = function()
    vim.schedule(refresh_cursor_visibility)
  end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "WinClosed", "BufWinEnter", "BufWinLeave" }, {
  group = ui,
  callback = function()
    vim.schedule(refresh_dashboard_visibility)
  end,
})
