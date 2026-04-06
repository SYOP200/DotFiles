return {
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      default = true,
      color_icons = true,
      strict = true,
      override_by_extension = {
        lua = { icon = "", color = "#a6e3a1", name = "Lua" },
        py = { icon = "", color = "#a6e3a1", name = "Py" },
        js = { icon = "", color = "#a6e3a1", name = "Js" },
        jsx = { icon = "", color = "#a6e3a1", name = "Jsx" },
        ts = { icon = "", color = "#a6e3a1", name = "Ts" },
        tsx = { icon = "", color = "#a6e3a1", name = "Tsx" },
        go = { icon = "", color = "#a6e3a1", name = "Go" },
        rs = { icon = "", color = "#a6e3a1", name = "Rs" },
        c = { icon = "", color = "#a6e3a1", name = "C" },
        cpp = { icon = "", color = "#a6e3a1", name = "Cpp" },
        h = { icon = "", color = "#a6e3a1", name = "H" },
        hpp = { icon = "", color = "#a6e3a1", name = "Hpp" },
        java = { icon = "", color = "#a6e3a1", name = "Java" },
        sh = { icon = "", color = "#a6e3a1", name = "Sh" },
        bash = { icon = "", color = "#a6e3a1", name = "Bash" },
        zsh = { icon = "", color = "#a6e3a1", name = "Zsh" },
        html = { icon = "", color = "#a6e3a1", name = "Html" },
        css = { icon = "", color = "#a6e3a1", name = "Css" },
        scss = { icon = "", color = "#a6e3a1", name = "Scss" },
        json = { icon = "", color = "#a6e3a1", name = "Json" },
        yaml = { icon = "", color = "#a6e3a1", name = "Yaml" },
        yml = { icon = "", color = "#a6e3a1", name = "Yml" },
        toml = { icon = "", color = "#a6e3a1", name = "Toml" },
        md = { icon = "", color = "#bac2de", name = "Md" },
        txt = { icon = "󰈙", color = "#bac2de", name = "Txt" },
        log = { icon = "󰌱", color = "#bac2de", name = "Log" },
      },
      override_by_filename = {
        ["README"] = { icon = "󰂺", color = "#bac2de", name = "Readme" },
        ["README.md"] = { icon = "󰂺", color = "#bac2de", name = "ReadmeMd" },
        [".gitignore"] = { icon = "", color = "#f38ba8", name = "Gitignore" },
      },
      override = {
        default_icon = { icon = "", color = "#f38ba8", name = "Default" },
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      default_component_configs = {
        indent = {
          with_markers = false,
          indent_size = 2,
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          default = "",
        },
        modified = {
          symbol = "●",
          highlight = "NeoTreeModified",
        },
        git_status = {
          symbols = {
            added = "+",
            deleted = "✖",
            modified = "~",
            renamed = "󰁕",
            untracked = "?",
            ignored = "",
            unstaged = "!",
            staged = "",
            conflict = "",
          },
        },
        name = {
          use_git_status_colors = true,
        },
      },
      window = {
        width = 32,
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "css",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitattributes",
        "gitignore",
        "jsonc",
        "scss",
        "ssh_config",
      })
      opts.highlight = vim.tbl_deep_extend("force", opts.highlight or {}, {
        enable = true,
        additional_vim_regex_highlighting = false,
      })
      opts.indent = vim.tbl_deep_extend("force", opts.indent or {}, {
        enable = true,
      })
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterBlue",
          "RainbowDelimiterLavender",
          "RainbowDelimiterSapphire",
          "RainbowDelimiterPeach",
          "RainbowDelimiterGreen",
          "RainbowDelimiterYellow",
        },
      }
    end,
  },
}
