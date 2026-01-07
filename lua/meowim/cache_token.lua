if vim.env["MEO_DISABLE_CACHE"] then return end

local config_dir = vim.fn.stdpath("config")
local token_path = config_dir .. "/cache_token"

-- Refresh token in the background
vim.schedule(function()
  vim.system({ "git", "-C", config_dir, "rev-parse", "HEAD" }, nil, function(out)
    local sha = vim.trim(out.stdout or "")
    if sha ~= "" then io.open(token_path, "w"):write(out.stdout) end
  end)
end)

local f = io.open(token_path, "r")
return f and f:read("*a") or tostring(math.random(0, 0xffffffff))
