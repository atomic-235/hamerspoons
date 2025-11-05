-- Load TimeEntry spoon
local timeEntry = hs.loadSpoon("TimeEntry")
if timeEntry then
    timeEntry:start()
    hs.alert.show("TimeEntry spoon loaded (Ctrl+Cmd+T)", 1.5)
else
    hs.alert.show("Failed to load TimeEntry spoon", 1.5)
end

-- Load WindowSelector spoon
local windowSelector = hs.loadSpoon("WindowSelector")
if windowSelector then
    windowSelector:start()
    hs.alert.show("WindowSelector spoon loaded (Option+Tab)", 1.5)
else
    hs.alert.show("Failed to load WindowSelector spoon", 1.5)
end
