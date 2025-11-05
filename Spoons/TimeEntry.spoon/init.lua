--- === TimeEntry ===
---
--- Description: Spoon for entering current date and time in ISO format
---
--- Download: [https://github.com/Hammerspoon/Spoons](https://github.com/Hammerspoon/Spoons)
--- Source: [https://github.com/Hammerspoon/Spoons/blob/master/Spoons/TimeEntry.spoon/init.lua](https://github.com/Hammerspoon/Spoons/blob/master/Spoons/TimeEntry.spoon/init.lua)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "TimeEntry"
obj.version = "1.0"
obj.author = "Atomic235"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- TimeEntry.defaultHotkey
--- Variable
--- Default hotkey to insert current time
--- Default: `{{"cmd", "ctrl"}, "t"}`
obj.defaultHotkey = { { "cmd", "ctrl" }, "t" }

--- TimeEntry.logger
--- Variable
--- Logger object used within the Spoon. Can be accessed to set the default log level for the messages coming from the Spoon.
obj.logger = hs.logger.new(obj.name)

--- TimeEntry.bindHotkeys(mapping)
--- Method
--- Binds hotkeys for TimeEntry
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key key pairs. Defaults to `TimeEntry.defaultHotkey`
function obj:bindHotkeys(mapping)
    if (not mapping) then
        mapping = {
            insertTime = self.defaultHotkey
        }
    end

    local hotkeySpec = mapping.insertTime
    local modifiers, key = hotkeySpec[1], hotkeySpec[2]

    self.hotkey = hs.hotkey.bind(modifiers, key, function()
        self:insertCurrentTime()
    end)

    return self
end

--- TimeEntry:init()
--- Method
--- Initialize TimeEntry spoon
---
--- Parameters:
---  * None
function obj:init()
    self.logger.i("Initializing TimeEntry spoon")
    return self
end

--- TimeEntry:insertCurrentTime()
--- Method
--- Gets current date and time and inserts it at cursor position or copies to clipboard
---
--- Parameters:
---  * None
function obj:insertCurrentTime()
    -- Get current date and time in YYYY-MM-DD HH:MM format
    local dateTimeString = os.date("%Y-%m-%d %H:%M")

    self.logger.i("Current date and time: " .. dateTimeString)

    -- Get the focused application
    local focusedApp = hs.application.frontmostApplication()
    if not focusedApp then
        hs.alert.show("No focused application", 1.5)
        return
    end

    -- Try to type the date and time string
    local success = hs.eventtap.keyStrokes(dateTimeString)

    if success then
        hs.alert.show("Inserted: " .. dateTimeString, 1.0)
    else
        -- If typing fails, copy to clipboard as fallback
        hs.pasteboard.setContents(dateTimeString)
        hs.alert.show("Copied to clipboard: " .. dateTimeString, 1.5)
    end
end

--- TimeEntry:start()
--- Method
--- Start the TimeEntry spoon
---
--- Parameters:
---  * None
function obj:start()
    self.logger.i("Starting TimeEntry spoon")

    -- Bind default hotkeys
    if not self.hotkey then
        self:bindHotkeys()
    end

    hs.alert.show("TimeEntry spoon started", 1.0)
    return self
end

--- TimeEntry:stop()
--- Method
--- Stop the TimeEntry spoon
---
--- Parameters:
---  * None
function obj:stop()
    self.logger.i("Stopping TimeEntry spoon")

    -- Unbind hotkeys
    if self.hotkey then
        self.hotkey:delete()
        self.hotkey = nil
    end

    hs.alert.show("TimeEntry spoon stopped", 1.0)
    return self
end

return obj
