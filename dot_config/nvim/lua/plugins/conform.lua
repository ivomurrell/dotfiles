return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  cmd = { 'ConformInfo', 'FormatEnable', 'FormatDisable' },
  opts = function()
    local config = {
      formatters_by_ft = {},
      format_after_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return {
          lsp_fallback = true,
        }
      end,
      formatters = {
        deno_fmt = {
          cwd = require("conform.util").root_file({ "deno.json", "deno.jsonc" }),
          require_cwd = true
        }
      }
    }
    local languages = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'css', 'scss', 'less',
      'html', 'json', 'jsonc', 'yaml', 'markdown', 'markdown.mdx', 'graphql', 'handlebars' }
    local deno_langs = { 'javascript', 'javascriptreact', 'json', 'jsonc', 'markdown', 'typescript', 'typescriptreact' }
    local function supportedByDeno(ft)
      for _, denolang in pairs(deno_langs) do
        if denolang == ft then
          return true
        end
      end
    end
    for _, lang in pairs(languages) do
      config.formatters_by_ft[lang] = supportedByDeno(lang) and
          { 'deno_fmt', 'prettierd', 'prettier', stop_after_first = true } or
          { 'prettierd', 'prettier', stop_after_first = true }
    end
    return config
  end,
  config = function(_, opts)
    require('conform').setup(opts)
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
  end
} -- Define non-LSP formatters
