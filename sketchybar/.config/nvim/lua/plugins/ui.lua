return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = false,
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local palette = require("catppuccin.palettes").get_palette("mocha")
      local function cwd_label()
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        return cwd ~= "" and cwd or vim.fn.getcwd()
      end

      opts.options = opts.options or {}
      opts.options.theme = {
        normal = {
          a = { fg = palette.base, bg = palette.peach, bold = true },
          b = { fg = palette.peach, bg = palette.mantle },
          c = { fg = palette.subtext1, bg = "NONE" },
        },
        insert = {
          a = { fg = palette.base, bg = palette.peach, bold = true },
          b = { fg = palette.peach, bg = palette.mantle },
        },
        visual = {
          a = { fg = palette.base, bg = palette.peach, bold = true },
          b = { fg = palette.peach, bg = palette.mantle },
        },
        replace = {
          a = { fg = palette.base, bg = palette.peach, bold = true },
          b = { fg = palette.peach, bg = palette.mantle },
        },
        command = {
          a = { fg = palette.base, bg = palette.peach, bold = true },
          b = { fg = palette.peach, bg = palette.mantle },
        },
        inactive = {
          a = { fg = palette.overlay1, bg = "NONE" },
          b = { fg = palette.overlay1, bg = "NONE" },
          c = { fg = palette.overlay0, bg = "NONE" },
        },
      }
      opts.options.globalstatus = true
      opts.options.component_separators = { left = "•", right = "•" }
      opts.options.section_separators = { left = "", right = "" }

      opts.sections = {
        lualine_a = { { "mode", icon = "" } },
        lualine_b = {
          { "filename", path = 1, symbols = { modified = " ●", readonly = " 󰌾", unnamed = " [No Name]" } },
        },
        lualine_c = {
          { cwd_label, icon = "" },
        },
        lualine_x = {
          { "filetype", icon_only = false, icon = { align = "left" } },
        },
        lualine_y = {
          { function() return os.date("%a %b %d") end, icon = "" },
        },
        lualine_z = {
          { function() return os.date("%H:%M") end, icon = "󰥔" },
        },
      }

      opts.inactive_sections = {
        lualine_a = {},
        lualine_b = {
          { "filename", path = 1 },
        },
        lualine_c = {
          { cwd_label, icon = "" },
        },
        lualine_x = {
          { "filetype" },
        },
        lualine_y = {
          { function() return os.date("%a %b %d") end, icon = "" },
        },
        lualine_z = {
          { function() return os.date("%H:%M") end, icon = "󰥔" },
        },
      }
    end,
  },
  {
    "akinsho/bufferline.nvim",
    optional = true,
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.always_show_bufferline = false
      opts.options.separator_style = "slant"
    end,
  },
}
