-- Menu bar lock: click for a menu of the names in `otp list`; picking one
-- copies its current MFA code to the clipboard.
--
-- The otp script (linked into ~/bin by install.sh) does the work: secrets
-- stay in the login Keychain and oathtool generates the codes.

local M = {}

local otpBin = os.getenv("HOME") .. "/bin/otp"
-- Hammerspoon's PATH has no Homebrew, which is where oathtool lives.
local otpPath = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

local lockedIcon = hs.image.imageFromName("NSLockLockedTemplate"):setSize({ w = 16, h = 16 })
local unlockedIcon = hs.image.imageFromName("NSLockUnlockedTemplate"):setSize({ w = 16, h = 16 })

-- The task and timer are kept on M so they are not garbage collected before
-- they finish.
function M.copy(name)
    M.task = hs.task.new(otpBin, function(exitCode, _, stdErr)
        hs.alert.show((stdErr:gsub("%s+$", "")))
        if exitCode == 0 then
            -- Flash the open lock while the code is fresh on the clipboard.
            M.menu:setIcon(unlockedIcon)
            M.timer = hs.timer.doAfter(3, function() M.menu:setIcon(lockedIcon) end)
        end
    end, { name })
    local env = M.task:environment()
    env.PATH = otpPath
    M.task:setEnvironment(env)
    M.task:start()
end

-- Rebuilt every time the menu opens, so new `otp add` entries show up on
-- their own.
function M.items()
    local names = hs.execute("PATH=" .. otpPath .. " '" .. otpBin .. "' list") or ""
    local items = {}
    for name in names:gmatch("[^\n]+") do
        table.insert(items, { title = name, fn = function() M.copy(name) end })
    end
    if #items == 0 then
        table.insert(items, { title = "No codes stored (otp add <name>)", disabled = true })
    end
    return items
end

-- Kept on the returned table so the menu bar item is not garbage collected.
M.menu = hs.menubar.new()

if M.menu then
    M.menu:setIcon(lockedIcon)
    M.menu:setTooltip("Copy an OTP code")
    M.menu:setMenu(M.items)
end

return M
