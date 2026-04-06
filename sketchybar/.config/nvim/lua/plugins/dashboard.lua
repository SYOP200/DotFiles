return {
  {
    "nvimdev/dashboard-nvim",
    lazy = false,
    opts = function()
      local stats = require("lazy").stats()
      local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
      local status = "transparent / " .. (vim.g.colors_name or require("config.colorscheme").get()) .. " / " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"

      local logo = table.concat({
        "███████╗██╗   ██╗ ██████╗ ██████╗ ██████╗  ██████╗  ██████╗ ",
        "██╔════╝╚██╗ ██╔╝██╔═══██╗██╔══██╗╚════██╗██╔═████╗██╔═████╗",
        "███████╗ ╚████╔╝ ██║   ██║██████╔╝ █████╔╝██║██╔██║██║██╔██║",
        "╚════██║  ╚██╔╝  ██║   ██║██╔═══╝ ██╔═══╝ ████╔╝██║████╔╝██║",
        "███████║   ██║   ╚██████╔╝██║     ███████╗╚██████╔╝╚██████╔╝",
        "╚══════╝   ╚═╝    ╚═════╝ ╚═╝     ╚══════╝ ╚═════╝  ╚═════╝ ",
        "",
        status,
        "",
        "",
      }, "\n")

      local mappings = {
        f = function() LazyVim.pick()() end,
        r = function() LazyVim.pick("oldfiles")() end,
        g = function() LazyVim.pick("live_grep")() end,
        e = function() vim.cmd("Neotree toggle") end,
        b = function() vim.cmd("Telescope buffers") end,
        c = function() LazyVim.pick.config_files()() end,
        n = function() vim.cmd("ene | startinsert") end,
        h = function() vim.cmd("Telescope git_files") end,
        m = function() vim.cmd("Mason") end,
        s = function() require("persistence").load() end,
        d = function() vim.cmd("Trouble diagnostics toggle") end,
        t = function() require("config.colorscheme").select() end,
        x = function() vim.cmd("LazyExtras") end,
        l = function() vim.cmd("Lazy") end,
        q = function() vim.cmd("qa") end,
      }

      local items = {
        { key = "f", text = "Find files" },
        { key = "r", text = "Recent files" },
        { key = "g", text = "Live grep" },
        { key = "e", text = "File explorer" },
        { key = "b", text = "Open buffers" },
        { key = "c", text = "Configure" },
        { key = "n", text = "New buffer" },
        { key = "h", text = "Git files" },
        { key = "m", text = "LSP tools" },
        { key = "s", text = "Session" },
        { key = "d", text = "Diagnostics" },
        { key = "t", text = "Set theme" },
        { key = "x", text = "Lazy extras" },
        { key = "l", text = "Plugin manager" },
        { key = "q", text = "Quit Nvim" },
      }

      local columns = 3
      local gap = "      "
      local widths = { 0, 0, 0 }
      for index, item in ipairs(items) do
        local text = string.format("[%s] %s", item.key, item.text)
        local column = ((index - 1) % columns) + 1
        widths[column] = math.max(widths[column], vim.fn.strdisplaywidth(text))
      end

      local rows = {}
      for index = 1, #items, columns do
        local parts = {}
        for column = 1, columns do
          local item = items[index + column - 1]
          if item then
            local text = string.format("[%s] %s", item.key, item.text)
            local width = vim.fn.strdisplaywidth(text)
            table.insert(parts, text .. string.rep(" ", widths[column] - width))
          end
        end
        table.insert(rows, table.concat(parts, gap))
      end

      local center = {}
      for _, text in ipairs(rows) do
        table.insert(center, {
          icon = "",
          desc = text,
          desc_hl = "DashboardCenter",
          key_hl = "DashboardShortcut",
          action = function() end,
        })
      end

      return {
        theme = "doom",
        hide = {
          statusline = false,
        },
        config = {
          vertical_center = true,
          header = vim.split(logo, "\n"),
          center = center,
          footer = {},
        },
        _mappings = mappings,
        _status = status,
        _items = items,
        _columns = columns,
      }
    end,
    config = function(_, opts)
      local mappings = opts._mappings or {}
      local status = opts._status
      local items = opts._items or {}
      local columns = opts._columns or 3
      opts._mappings = nil
      opts._status = nil
      opts._items = nil
      opts._columns = nil

      local group = vim.api.nvim_create_augroup("syop200_dashboard_keys", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "dashboard",
        callback = function(event)
          pcall(vim.api.nvim_del_augroup_by_name, "DashboardDoomCursor")

          vim.bo[event.buf].buftype = "nofile"
          vim.bo[event.buf].bufhidden = "wipe"
          vim.bo[event.buf].swapfile = false
          vim.bo[event.buf].modifiable = false
          vim.bo[event.buf].modified = false
          vim.bo[event.buf].readonly = true

          if _G.SYOP200_set_cursor_visibility then
            _G.SYOP200_set_cursor_visibility(false)
          end
          if _G.SYOP200_refresh_cursor_visibility then
            vim.schedule(_G.SYOP200_refresh_cursor_visibility)
          end

          for key, action in pairs(mappings) do
            vim.keymap.set("n", key, action, {
              buffer = event.buf,
              nowait = true,
              silent = true,
              desc = "Dashboard " .. key,
            })
          end

          vim.b[event.buf].syop200_dashboard_status = status
          vim.bo[event.buf].modifiable = false

          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(event.buf) then
              return
            end
            local ns = vim.api.nvim_create_namespace("syop200_dashboard_hl")
            vim.api.nvim_buf_clear_namespace(event.buf, ns, 0, -1)
            local lines = vim.api.nvim_buf_get_lines(event.buf, 0, -1, false)
            for line_nr, line in ipairs(lines) do
              if status and line:find(status, 1, true) then
                vim.api.nvim_buf_add_highlight(event.buf, ns, "DashboardFooter", line_nr - 1, 0, -1)
              end
              local start_col = 1
              while true do
                local s, e = line:find("%[[%w]%]", start_col)
                if not s then
                  break
                end
                vim.api.nvim_buf_add_highlight(event.buf, ns, "DashboardShortcut", line_nr - 1, s - 1, e)
                start_col = e + 1
              end
            end

            local function map(lhs, rhs, desc)
              vim.keymap.set("n", lhs, rhs, {
                buffer = event.buf,
                nowait = true,
                silent = true,
                desc = desc,
              })
            end

            map("<Left>", "<Nop>", "Dashboard Left Disabled")
            map("<Right>", "<Nop>", "Dashboard Right Disabled")
            map("<Down>", "<Nop>", "Dashboard Down Disabled")
            map("<Up>", "<Nop>", "Dashboard Up Disabled")
            map("h", "<Nop>", "Dashboard Left Disabled")
            map("j", "<Nop>", "Dashboard Down Disabled")
            map("k", "<Nop>", "Dashboard Up Disabled")
            map("l", "<Nop>", "Dashboard Right Disabled")
            map("<CR>", "<Nop>", "Dashboard Select Disabled")

            local win = vim.fn.bufwinid(event.buf)
            if win ~= -1 then
              vim.api.nvim_win_set_cursor(win, { 1, 0 })
              vim.wo[win].cursorline = false
              vim.wo[win].cursorcolumn = false
              vim.wo[win].winhl =
                "CursorLine:Normal,CursorLineNr:Normal,Cursor:CursorHidden,TermCursor:CursorHidden"
            end
          end)
        end,
      })

      require("dashboard").setup(opts)
    end,
  },
}
