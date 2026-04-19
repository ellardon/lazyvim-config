--- ts-node-highlight.nvim
--- Highlights treesitter nodes whose types match two configurable lists:
--- "operands" (values, literals) and "operators" (operations, punctuation).
---
--- Each group has its own highlight group and can be toggled independently,
--- either for the whole buffer or for a line range selected in Visual mode.
---
--- Usage (in your lazy spec opts):
---   opts = {
---     operands  = { node_types = { "string", "number" }, hl_group = "TsOperandHL" },
---     operators = { node_types = { "+", "-" },           hl_group = "TsOperatorHL" },
---   }

local M = {}

--- Default node types for each group.
M.defaults = {
  operands = {
    node_types = {
      "string",
      "string_content",
      "number",
      "float",
      "boolean",
      "null",
      "character",
      "raw_string",
    },
    hl_group = "TsOperandHighlight",
  },
  operators = {
    node_types = {
      "operator",
      "binary_operator",
      "unary_operator",
      "augmented_assignment_operator",
      "comparison_operator",
      "boolean_operator",
      "not_operator",
      "arithmetic_operator",
      "bitwise_operator",
      "shift_operator",
    },
    hl_group = "TsOperatorHighlight",
  },
}

--- Resolved configuration (populated by M.setup).
M.config = {}

--- Whole-buffer highlight namespaces, one per group.
local ns_buf = {
  operands = vim.api.nvim_create_namespace("ts_node_highlight_operands"),
  operators = vim.api.nvim_create_namespace("ts_node_highlight_operators"),
}

--- Range highlight namespace (shared; extmarks carry the hl_group themselves).
local ns_range = vim.api.nvim_create_namespace("ts_node_highlight_range")

--- Active ranges per buffer per group.
--- Structure: active_ranges[buf][group] = { {start_line, end_line}, ... }
--- Lines are 0-indexed.
---@type table<integer, table<string, {[1]:integer,[2]:integer}[]>>
local active_ranges = {}

--- Build a fast lookup set from a list.
---@param list string[]
---@return table<string, boolean>
local function to_set(list)
  local set = {}
  for _, v in ipairs(list) do
    set[v] = true
  end
  return set
end

--- Apply highlights for `group` within [start_line, end_line] (0-indexed, inclusive).
--- Returns the number of nodes highlighted.
---@param buf integer
---@param group "operands"|"operators"
---@param start_line integer
---@param end_line integer
---@param ns integer  namespace to write into
---@return integer
local function highlight_range(buf, group, start_line, end_line, ns)
  local ok, parser = pcall(vim.treesitter.get_parser, buf)
  if not ok or not parser then
    return 0
  end

  local node_set = to_set(M.config[group].node_types)
  local hl_group = M.config[group].hl_group
  local count = 0

  -- Only walk the root (host-language) tree to avoid double-counting nodes
  -- that appear in both the host tree and injected language trees (e.g. format
  -- string contents parsed by a secondary treesitter parser).
  local root = parser:parse()[1]:root()

  ---@param node TSNode
  local function walk(node)
    local sr, sc, er, ec = node:range()
    -- Skip nodes entirely outside the range.
    if er < start_line or sr > end_line then
      return
    end
    if node_set[node:type()] then
      -- Clamp to the requested line range.
      local csr = math.max(sr, start_line)
      local cer = math.min(er, end_line)
      local csc = (sr < start_line) and 0 or sc
      local cec = (er > end_line) and -1 or ec
      vim.api.nvim_buf_set_extmark(buf, ns, csr, csc, {
        end_row = cer,
        end_col = cec,
        hl_group = hl_group,
        priority = 110,
      })
      count = count + 1
    end
    for child in node:iter_children() do
      walk(child)
    end
  end

  walk(root)

  return count
end

--- Clear whole-buffer highlights for a group.
---@param buf integer
---@param group "operands"|"operators"
local function clear_buf(buf, group)
  vim.api.nvim_buf_clear_namespace(buf, ns_buf[group], 0, -1)
end

--- Clear all range highlights for a buffer (all groups).
---@param buf integer
local function clear_ranges(buf)
  vim.api.nvim_buf_clear_namespace(buf, ns_range, 0, -1)
  active_ranges[buf] = nil
end

--- Re-draw all active range highlights for a buffer.
---@param buf integer
local function redraw_ranges(buf)
  vim.api.nvim_buf_clear_namespace(buf, ns_range, 0, -1)
  local buf_ranges = active_ranges[buf]
  if not buf_ranges then
    return
  end
  for _, group in ipairs({ "operands", "operators" }) do
    for _, r in ipairs(buf_ranges[group] or {}) do
      highlight_range(buf, group, r[1], r[2], ns_range)
    end
  end
end

--- Apply whole-buffer highlights for a group. Returns the node count.
---@param buf integer
---@param group "operands"|"operators"
---@return integer
local function highlight_buf_group(buf, group)
  if not vim.api.nvim_buf_is_valid(buf) then
    return 0
  end
  clear_buf(buf, group)
  return highlight_range(buf, group, 0, math.huge, ns_buf[group])
end

--- Notify the user about a highlight action.
---@param group "operands"|"operators"
---@param action string   e.g. "enabled", "disabled", "range on", "range off"
---@param count integer?  number of nodes highlighted (nil = no count)
local function notify(group, action, count)
  local msg = "TSHighlight " .. group .. ": " .. action
  if count then
    msg = msg .. " (" .. count .. " node" .. (count == 1 and "" or "s") .. ")"
  end
  vim.notify(msg, vim.log.levels.INFO)
end

--- Refresh all highlights (whole-buffer groups + ranges) for a buffer.
---@param buf integer
local function refresh_buf(buf)
  for _, group in ipairs({ "operands", "operators" }) do
    if M.config[group].enabled then
      highlight_buf_group(buf, group)
    else
      clear_buf(buf, group)
    end
  end
  redraw_ranges(buf)
end

--- Set up the plugin.
---@param opts? table
function M.setup(opts)
  opts = opts or {}

  for _, group in ipairs({ "operands", "operators" }) do
    local user = opts[group] or {}
    local def = M.defaults[group]
    M.config[group] = {
      node_types = user.node_types or def.node_types,
      hl_group = user.hl_group or def.hl_group,
      enabled = user.enabled ~= nil and user.enabled or false,
    }
  end

  -- Define default highlight groups (overridable by colorscheme / user).
  vim.api.nvim_set_hl(0, "TsOperandHighlight", {
    default = true,
    bg = "#3b4252",
  })
  vim.api.nvim_set_hl(0, "TsOperatorHighlight", {
    default = true,
    bg = "#4c3a2a",
  })

  vim.api.nvim_create_user_command("TSHighlight", function(cmd)
    local args = vim.split(vim.trim(cmd.args), "%s+")
    local subcmd = args[1]

    if subcmd == "operands" then
      M.toggle("operands")
    elseif subcmd == "operators" then
      M.toggle("operators")
    elseif subcmd == "refresh" then
      M.refresh()
    elseif subcmd == "clear" then
      M.clear()
    elseif subcmd == "range" then
      local group = args[2]
      if group ~= "operands" and group ~= "operators" then
        vim.notify(
          "TSHighlight range: specify 'operands' or 'operators'.",
          vim.log.levels.WARN
        )
        return
      end
      -- Read the last visual selection marks (1-indexed lines → 0-indexed).
      local start_line = vim.fn.line("'<") - 1
      local end_line = vim.fn.line("'>") - 1
      M.toggle_range(group, start_line, end_line)
    else
      vim.notify(
        "TSHighlight: unknown subcommand '" .. (subcmd or "") .. "'."
          .. " Use 'operands', 'operators', 'refresh', 'clear', or 'range operands|operators'.",
        vim.log.levels.WARN
      )
    end
  end, {
    nargs = "+",
    range = true, -- allow being called with a visual range (sets '< and '>)
    complete = function(arg_lead, cmd_line)
      local parts = vim.split(vim.trim(cmd_line), "%s+")
      if #parts == 2 then
        -- Completing first argument.
        return vim.tbl_filter(function(v)
          return v:find(arg_lead, 1, true) == 1
        end, { "operands", "operators", "refresh", "clear", "range" })
      elseif #parts == 3 and parts[2] == "range" then
        -- Completing second argument after "range".
        return vim.tbl_filter(function(v)
          return v:find(arg_lead, 1, true) == 1
        end, { "operands", "operators" })
      end
      return {}
    end,
    desc = "TS node highlight commands",
  })

  local augroup = vim.api.nvim_create_augroup("TsNodeHighlight", { clear = true })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "TextChangedI" }, {
    group = augroup,
    callback = function(ev)
      refresh_buf(ev.buf)
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    group = augroup,
    pattern = "TSUpdate",
    callback = function(ev)
      refresh_buf(ev.buf)
    end,
  })

  -- Clean up range state when a buffer is wiped.
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = augroup,
    callback = function(ev)
      active_ranges[ev.buf] = nil
    end,
  })

  -- Apply to already-open buffers.
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      refresh_buf(buf)
    end
  end
end

--- Refresh highlights for the current buffer (respects enabled state per group).
function M.refresh()
  local buf = vim.api.nvim_get_current_buf()
  local counts = {}
  for _, group in ipairs({ "operands", "operators" }) do
    if M.config[group].enabled then
      counts[group] = highlight_buf_group(buf, group)
    else
      clear_buf(buf, group)
    end
  end
  redraw_ranges(buf)
  local parts = {}
  for _, group in ipairs({ "operands", "operators" }) do
    if counts[group] then
      local c = counts[group]
      table.insert(parts, group .. ": " .. c .. " node" .. (c == 1 and "" or "s"))
    end
  end
  if #parts > 0 then
    vim.notify("TSHighlight refresh — " .. table.concat(parts, ", "), vim.log.levels.INFO)
  end
end

--- Toggle whole-buffer highlighting for a group.
---@param group "operands"|"operators"
function M.toggle(group)
  M.config[group].enabled = not M.config[group].enabled
  local buf = vim.api.nvim_get_current_buf()
  if M.config[group].enabled then
    local count = highlight_buf_group(buf, group)
    notify(group, "enabled", count)
  else
    clear_buf(buf, group)
    notify(group, "disabled")
  end
end

--- Toggle range highlighting for a group on [start_line, end_line] (0-indexed).
--- If the exact same range is already active for the group it is removed (toggle off).
---@param group "operands"|"operators"
---@param start_line integer  0-indexed
---@param end_line   integer  0-indexed
function M.toggle_range(group, start_line, end_line)
  local buf = vim.api.nvim_get_current_buf()

  active_ranges[buf] = active_ranges[buf] or {}
  active_ranges[buf][group] = active_ranges[buf][group] or {}

  local ranges = active_ranges[buf][group]

  -- Check if this exact range is already active → toggle it off.
  for i, r in ipairs(ranges) do
    if r[1] == start_line and r[2] == end_line then
      table.remove(ranges, i)
      redraw_ranges(buf)
      notify(group, "range off (lines " .. (start_line + 1) .. "-" .. (end_line + 1) .. ")")
      return
    end
  end

  -- Not found → add it and count placed nodes.
  table.insert(ranges, { start_line, end_line })
  -- Count by temporarily highlighting into a scratch namespace.
  local ns_tmp = vim.api.nvim_create_namespace("")
  local count = highlight_range(buf, group, start_line, end_line, ns_tmp)
  vim.api.nvim_buf_clear_namespace(buf, ns_tmp, 0, -1)
  redraw_ranges(buf)
  notify(group, "range on (lines " .. (start_line + 1) .. "-" .. (end_line + 1) .. ")", count)
end

--- Clear all range highlights in the current buffer.
function M.clear_ranges()
  clear_ranges(vim.api.nvim_get_current_buf())
  vim.notify("TSHighlight: all range highlights cleared", vim.log.levels.INFO)
end

--- Clear all highlights (whole-buffer and ranges) in the current buffer
--- and disable both groups.
function M.clear()
  local buf = vim.api.nvim_get_current_buf()
  for _, group in ipairs({ "operands", "operators" }) do
    M.config[group].enabled = false
    clear_buf(buf, group)
  end
  clear_ranges(buf)
  vim.notify("TSHighlight: all highlights cleared", vim.log.levels.INFO)
end

return M
