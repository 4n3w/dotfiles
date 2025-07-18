hs.loadSpoon("ShiftIt")
spoon.ShiftIt:bindHotkeys({})

alert = require 'hs.alert'
HYPER = { "cmd", "alt", "ctrl", "shift" }

ampOnIcon = [[ASCII:
.....1a..........AC..........E
..............................
......4.......................
1..........aA..........CE.....
e.2......4.3...........h......
..............................
..............................
.......................h......
e.2......6.3..........t..q....
5..........c..........s.......
......6..................q....
......................s..t....
.....5c.......................
]]

ampOffIcon = [[ASCII:
.....1a.....x....AC.y.......zE
..............................
......4.......................
1..........aA..........CE.....
e.2......4.3...........h......
..............................
..............................
.......................h......
e.2......6.3..........t..q....
5..........c..........s.......
......6..................q....
......................s..t....
...x.5c....y.......z..........
]]

-- caffeine replacement
local caffeine = hs.menubar.new()

function setCaffeineDisplay(state)
    if state then
        caffeine:setIcon(ampOnIcon)
    else
        caffeine:setIcon(ampOffIcon)
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

-- Based on https://github.com/atsepkov/hammerspoon-config/blob/master/modules/pomodoor.lua

-- Pomodoro module
local pom_work_period_sec  = 25 * 60
local pom_rest_period_sec  = 5 * 60
local pom_work_count       = 0
local pom_curr_active_type = "W" -- {"work", "rest"}
local pom_is_active        = false
local pom_time_left        = pom_work_period_sec
local pom_disable_count    = 0

-- update display
local function pom_update_display()
    -- local time_min = math.floor( (pom_time_left / 60))
    -- local time_sec = pom_time_left - (time_min * 60)
    local time_granular = math.floor(pom_time_left / 60 + 0.5)
    local str = string.format("s: %s m: %02d c: %02d", pom_curr_active_type, time_granular, pom_work_count)
    pom_menu:setTitle(str)
end

-- stop the clock
-- Stateful:
-- * Disabling once will pause the countdown
-- * Disabling twice will reset the countdown
-- * Disabling trice will shut down and hide the pomodoro timer
function pom_disable()
    local pom_was_active = pom_is_active
    pom_is_active = false

    if (pom_disable_count == 0) then
        hs.alert.show("Pomodoro paused", 2)
        if (pom_was_active) then
            pom_timer:stop()
        end
    elseif (pom_disable_count == 1) then
        hs.alert.show("Resetting Pomodoro...", 2)
        pom_time_left        = pom_work_period_sec
        pom_curr_active_type = "W"
        pom_update_display()
    elseif (pom_disable_count >= 2) then
        hs.alert.show("Shutting down Pomodoro...", 2)
        if pom_menu == nil then
            pom_disable_count = 2
            return
        end
        pom_menu:delete()
        pom_menu = nil
        pom_timer:stop()
        pom_timer = nil
    end

    pom_disable_count = pom_disable_count + 1
end

-- update pomodoro timer
local function pom_update_time()
    if pom_is_active == false then
        return
    else
        pom_time_left = pom_time_left - 1

        if (pom_time_left <= 0) then
            pom_disable()
            if pom_curr_active_type == "W" then
                hs.alert.show("Work Complete!", 2)
                pom_work_count       = pom_work_count + 1
                pom_curr_active_type = "R"
                pom_time_left        = pom_rest_period_sec
            else
                hs.alert.show("Done resting", 2)
                pom_curr_active_type = "W"
                pom_time_left        = pom_work_period_sec
            end
        end
    end
end

-- update menu display
local function pom_update_menu()
    pom_update_time()
    pom_update_display()
end

local function pom_create_menu(pom_origin)
    if pom_menu == nil then
        pom_menu = hs.menubar.new()
    end
end

function pom_enable()
    pom_disable_count = 0;
    if (pom_is_active) then
        hs.alert.show("Pomodoro already started", 1)
        return
    elseif pom_timer == nil then
        hs.alert.show("Starting Pomodoro...", 2)
        pom_create_menu()
        pom_timer = hs.timer.new(1, pom_update_menu)
    end

    pom_is_active = true
    pom_timer:start()
end

-- Use examples:

-- init pomodoro -- show menu immediately
-- pom_create_menu()
-- pom_update_menu()

-- show menu only on first pom_enable
--hs.hotkey.bind(mash, '9', function() pom_enable() end)
--hs.hotkey.bind(mash, '0', function() pom_disable() end)

init = function()
    -- pom_create_menu()
    -- pom_update_menu()
    hs.hotkey.bind(HYPER, '=', function() pom_enable() end)
    hs.hotkey.bind(HYPER, '-', function() pom_disable() end)
end

init()
