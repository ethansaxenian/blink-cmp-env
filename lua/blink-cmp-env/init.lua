--- @module 'blink.cmp'

--- @class blink-cmp-env.Opts
--- @field include_snippets? boolean
--- @field insert_variable_prefix? boolean

--- @type blink-cmp-env.Opts
local default_opts = {
  include_snippets = true,
  insert_variable_prefix = true,
}

--- @class blink-cmp-env.Source: blink.cmp.Source
--- @field opts blink-cmp-env.Opts
local M = {}

--- @param opts blink-cmp-env.Opts
function M.new(opts)
  --- @type blink-cmp-env.Opts
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})

  vim.validate("full_history", opts.include_snippets, "boolean")
  vim.validate("full_history", opts.insert_variable_prefix, "boolean")

  local self = setmetatable({}, { __index = M })
  self.opts = opts
  return self
end

function M:get_completions(_, callback)
  local env_vars = vim.fn.environ()
  local items = {}
  for key, value in pairs(env_vars) do
    local snippet_key = key
    local completion_key = key
    if self.opts.insert_variable_prefix then
      completion_key = "$" .. completion_key
    end

    table.insert(items, {
      label = completion_key,
      insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
      kind = require("blink.cmp.types").CompletionItemKind.Variable,
    })

    if self.opts.include_snippets then
      table.insert(items, {
        label = snippet_key,
        insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
        insertText = value,
        kind = require("blink.cmp.types").CompletionItemKind.Snippet,
        documentation = {
          kind = "markdown",
          value = value,
        },
      })
    end
  end

  callback({
    items = items,
    is_incomplete_backward = false,
    is_incomplete_forward = false,
  })

  return function() end
end

return M
