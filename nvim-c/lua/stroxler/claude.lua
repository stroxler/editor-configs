-- Claude Code helpers: send code selections to the Claude Code terminal

local function find_claude_code_buffer()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      local name = vim.api.nvim_buf_get_name(bufnr)
      if vim.fn.fnamemodify(name, ":t"):match("^claude%-code") then
        return bufnr
      end
    end
  end
  return nil
end

local function find_window_for_buf(bufnr)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      return win
    end
  end
  return nil
end

local function scroll_claude_code_to_bottom()
  local bufnr = find_claude_code_buffer()
  if not bufnr then return end
  local win = find_window_for_buf(bufnr)
  if not win then return end
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  vim.api.nvim_win_set_cursor(win, { line_count, 0 })
end

local function resolve_agent_command()
  local env_agent = vim.env.AGENT_COMMAND or os.getenv("AGENT_COMMAND")
  if env_agent and vim.trim(env_agent) ~= "" then
    return env_agent
  end
  return "claude"
end

local function submit_sequence_for_agent()
  local submit_mode = vim.env.AGENT_SUBMIT_SEQUENCE or os.getenv("AGENT_SUBMIT_SEQUENCE")
  if submit_mode and vim.trim(submit_mode) ~= "" then
    local normalized_mode = vim.trim(submit_mode):lower()
    if normalized_mode == "csiu" then
      return "\x1b[13u"
    end
    if normalized_mode == "cr" or normalized_mode == "enter" then
      return "\r"
    end
    -- Allow raw escape sequences for experimentation.
    return submit_mode
  end
  -- In Neovim terminal channels, carriage return is the most reliable submit key.
  return "\r"
end

local function refresh_claude_command_from_env()
  local ok, claude = pcall(require, "claude-code")
  if not ok or type(claude) ~= "table" or type(claude.config) ~= "table" then
    return
  end
  claude.config.command = resolve_agent_command()
end

local function send_to_claude_code(text)
  local bufnr = find_claude_code_buffer()
  if not bufnr then
    vim.notify("No agent terminal found. Open one first with :ClaudeCode", vim.log.levels.WARN)
    return
  end
  local chan = vim.api.nvim_buf_get_option(bufnr, "channel")
  if not chan or chan == 0 then
    vim.notify("Agent terminal has no active channel", vim.log.levels.WARN)
    return
  end
  vim.api.nvim_chan_send(chan, text)
end

local function get_visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line = start_pos[2]
  local end_line = end_pos[2]
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  return lines, start_line, end_line
end

local function send_selection_with_context()
  local file = vim.fn.expand("%:p")
  local ft = vim.bo.filetype
  local lines, start_line, end_line = get_visual_selection()

  local text = "```" .. ft .. " " .. file .. ":" .. start_line .. "-" .. end_line .. "\n"
  for _, line in ipairs(lines) do
    text = text .. line .. "\n"
  end
  text = text .. "```\n"

  send_to_claude_code(text)
end

local function send_file_path()
  send_to_claude_code("File: `" .. vim.fn.expand("%:p") .. "`\n")
end

local function send_prompt_to_claude()
  vim.ui.input({ prompt = "Agent: " }, function(input)
    if input and input ~= "" then
      send_to_claude_code(input)
      send_to_claude_code(submit_sequence_for_agent())
      vim.defer_fn(scroll_claude_code_to_bottom, 200)
      vim.notify("Prompt sent to agent terminal.", vim.log.levels.INFO)
    end
  end)
end

-- Commands
vim.api.nvim_create_user_command("ClaudeSend", function()
  send_selection_with_context()
end, { range = true })

vim.api.nvim_create_user_command("ClaudeSendFile", function()
  send_file_path()
end, {})

vim.api.nvim_create_user_command("ClaudePrompt", function()
  send_prompt_to_claude()
end, {})

vim.api.nvim_create_user_command("ClaudeScroll", function()
  scroll_claude_code_to_bottom()
end, {})

-- Open Claude Code and return focus to the current window
local function open_claude_code_background()
  local cur_win = vim.api.nvim_get_current_win()
  -- If Claude Code is already open, nothing to do
  local bufnr = find_claude_code_buffer()
  if bufnr and find_window_for_buf(bufnr) then
    vim.notify("Agent terminal is already open", vim.log.levels.INFO)
    return
  end
  -- Open Claude Code (this will move focus to its window)
  refresh_claude_command_from_env()
  vim.cmd("ClaudeCode")
  -- Return focus to the original window
  vim.defer_fn(function()
    if vim.api.nvim_win_is_valid(cur_win) then
      vim.api.nvim_set_current_win(cur_win)
    end
  end, 100)
end

vim.api.nvim_create_user_command("ClaudeOpen", function()
  open_claude_code_background()
end, {})

-- Keybindings (leader + d prefix)
vim.keymap.set("n", "<leader>df", function()
  refresh_claude_command_from_env()
  vim.cmd("ClaudeCode")
end, { desc = "Toggle agent terminal (focus)" })
vim.keymap.set("n", "<leader>do", "<cmd>ClaudeOpen<cr>", { desc = "Open agent terminal (stay in buffer)" })
vim.keymap.set("v", "<leader>ds", "<cmd>ClaudeSend<cr>", { desc = "Send selection to agent terminal" })
vim.keymap.set("n", "<leader>dp", "<cmd>ClaudeSendFile<cr>", { desc = "Send file path to agent terminal" })
vim.keymap.set("n", "<leader>dm", "<cmd>ClaudePrompt<cr>", { desc = "Send message to agent terminal (stay in buffer)" })
vim.keymap.set("n", "<leader><Space>", "<cmd>ClaudePrompt<cr>", { desc = "Send message to agent terminal" })
vim.keymap.set("n", "<leader>dj", "<cmd>ClaudeScroll<cr>", { desc = "Scroll agent terminal to bottom" })
