--- === WindowSelector ===
---
--- Spoon for searching and selecting windows from all spaces
---
--- Download: [https://github.com/Hammerspoon/Spoons](https://github.com/Hammerspoon/Spoons)
--- Source: [https://github.com/Hammerspoon/Spoons/blob/master/Spoons/WindowSelector.spoon/init.lua](https://github.com/Hammerspoon/Spoons/blob/master/Spoons/WindowSelector.spoon/init.lua)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "WindowSelector"
obj.version = "1.0"
obj.author = "Atomic235"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- WindowSelector.defaultHotkey
--- Variable
--- Default hotkey to show window search
--- Default: `{"alt"}, "tab"`
obj.defaultHotkey = { "alt", "tab" }

--- WindowSelector.logger
--- Variable
--- Logger object used within the Spoon. Can be accessed to set the default log level for the messages coming from the Spoon.
obj.logger = hs.logger.new(obj.name)

--- WindowSelector.windowSearch()
--- Method
--- Shows a chooser with all visible windows from all spaces
---
--- Parameters:
---  * None
function obj:windowSearch()
    -- Use orderedWindows() which tends to find more windows across spaces
    local allWindows = hs.window.orderedWindows()
    local windowList = {}

    for _, win in ipairs(allWindows) do
        local app = win:application()
        if app and app:isRunning() then
            local appName = app:name()
            local title = win:title() or "[No Title]"
            local windowID = win:id()
            local isStandard = win:isStandard()
            local isMinimized = win:isMinimized()

            -- Include standard windows that aren't minimized
            if isStandard and not isMinimized then
                -- Create a clean table for each window choice
                local choice = {
                    text = appName .. ": " .. title,
                    subText = "ID: " .. windowID,
                    id = windowID,
                    app = appName
                }
                table.insert(windowList, choice)
            end
        end
    end

    -- Sort by app name
    table.sort(windowList, function(a, b)
        return a.app < b.app
    end)

    local chooser = hs.chooser.new(function(choice)
        if not choice then return end
        local window = hs.window.get(choice.id)
        if window then
            local app = window:application()
            if app then
                -- Activate the app and focus the window
                app:activate()
                hs.timer.doAfter(0.1, function()
                    window:focus()
                end)
            end
        end
    end)

    -- Set choices with proper validation
    local validChoices = {}
    for _, choice in ipairs(windowList) do
        if choice and choice.text and choice.id then
            table.insert(validChoices, choice)
        end
    end

    chooser:choices(validChoices)
    chooser:placeholderText("Search windows...")
    chooser:show()
end

--- WindowSelector.bindHotkeys(mapping)
--- Method
--- Binds hotkeys for WindowSelector
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key key pairs. Defaults to `WindowSelector.defaultHotkey`
function obj:bindHotkeys(mapping)
    if (not mapping) or (not mapping.showWindowSearch) then
        mapping = {
            showWindowSearch = self.defaultHotkey
        }
    end

    self.hotkey = hs.hotkey.bind(mapping.showWindowSearch[1], mapping.hotkeyKey or mapping.showWindowSearch[2],
        function()
            self:windowSearch()
        end)

    return self
end

--- WindowSelector:init()
--- Method
--- Initialize WindowSelector spoon
---
--- Parameters:
---  * None
function obj:init()
    self.logger.i("Initializing WindowSelector spoon")
    return self
end

--- WindowSelector:start()
--- Method
--- Start the WindowSelector spoon
---
--- Parameters:
---  * None
function obj:start()
    self.logger.i("Starting WindowSelector spoon")

    -- Bind default hotkeys
    if not self.hotkey then
        self:bindHotkeys()
    end

    hs.alert.show("WindowSelector spoon started", 1.0)
    return self
end

--- WindowSelector:stop()
--- Method
--- Stop the WindowSelector spoon
---
--- Parameters:
---  * None
function obj:stop()
    self.logger.i("Stopping WindowSelector spoon")

    -- Unbind hotkeys
    if self.hotkey then
        self.hotkey:delete()
        self.hotkey = nil
    end

    hs.alert.show("WindowSelector spoon stopped", 1.0)
    return self
end

return obj
