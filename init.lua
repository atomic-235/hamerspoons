-- Window search function that shows windows from all spaces
function windowSearch()
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

-- Bind Option+Tab to window search
hs.hotkey.bind({ "alt" }, "tab", windowSearch)
hs.alert.show("Window search loaded (Option+Tab)", 1.5)
