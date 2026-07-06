-- Add spaces at Chinese/English candidate boundaries.
-- Works as a lua_filter; it changes candidates, not raw key input.

local M = {}
local CJK = "[\228-\233][\128-\191][\128-\191]"

local function has_cjk(s)
  return s and s:find(CJK) ~= nil
end

local function starts_cjk(s)
  return s and s:find("^%s*" .. CJK) ~= nil
end

local function ends_cjk(s)
  return s and s:find(CJK .. "%s*$") ~= nil
end

local function ascii_wordish(s)
  return s and s:find("%a") ~= nil and s:find("[^%w%p%s]") == nil
end

local function starts_ascii_wordish(s)
  return ascii_wordish(s) and s:find("^%s*[%w]") ~= nil
end

local function ends_ascii_wordish(s)
  return ascii_wordish(s) and s:find("[%w%+%#][%p%s]*$") ~= nil
end

local function add_inner_spaces(s)
  if not (has_cjk(s) and s:find("%a")) then
    return s
  end
  s = s:gsub("(" .. CJK .. ")([%w])", "%1 %2")
  s = s:gsub("([%w%+%#])(" .. CJK .. ")", "%1 %2")
  return s
end

local function needs_leading_space(prev, text)
  if not prev or prev == "" or prev:find("%s$") or text:find("^%s") then
    return false
  end
  if starts_ascii_wordish(text) then
    return ends_cjk(prev) or ends_ascii_wordish(prev)
  end
  if starts_cjk(text) then
    return ends_ascii_wordish(prev)
  end
  return false
end

function M.func(input, env)
  local context = env.engine.context
  local history = context.commit_history
  local latest_text = history and history:latest_text() or ""

  for cand in input:iter() do
    local candidate = cand
    local text = add_inner_spaces(candidate.text)
    if needs_leading_space(latest_text, text) then
      text = " " .. text
    end
    if text ~= candidate.text then
      candidate = candidate:to_shadow_candidate("en_spacer", text, candidate.comment)
    end
    yield(candidate)
  end
end

return M
