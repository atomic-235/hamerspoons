-- Window search function
function windowSearch()
    local allWindows = hs.window.allWindows()
    local windowList = {}

    for _, win in ipairs(allWindows) do
        local app = win:application()
        if app and app:isRunning() then
            local appName = app:name()
            local title = win:title() or "[No Title]"
            local windowID = win:id()
            local isStandard = win:isStandard()
            local isMinimized = win:isMinimized()

            if isStandard and not isMinimized then
                table.insert(windowList, {
                    text = appName .. ": " .. title,
                    subText = "ID: " .. windowID,
                    id = windowID,
                    app = appName
                })
            end
        end
    end

    table.sort(windowList, function(a, b)
        return a.app < b.app
    end)

    local chooser = hs.chooser.new(function(choice)
        if not choice then return end
        local window = hs.window.get(choice.id)
        if window then
            local app = window:application()
            if app then
                app:activate()
                hs.timer.doAfter(0.1, function()
                    window:focus()
                end)
            end
        end
    end)

    chooser:choices(windowList)
    chooser:placeholderText("Search windows...")
    chooser:show()
end

hs.hotkey.bind({ "cmd" }, "tab", windowSearch)
hs.alert.show("Window search loaded (Cmd+Tab)", 1.5)
