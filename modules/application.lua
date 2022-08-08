-- 应用切换

require 'modules.shortcut'

hs.fnutils.each(applications, function(item)
    hs.hotkey.bind(item.prefix, item.key, item.message, function()
        toggleAppByBundleId(item.bundleId)
    end)
end)

-- 存储鼠标位置
local mousePositions = {}

function toggleAppByBundleId(appBundleID)

    local previousFocusedWindow = hs.window.focusedWindow()
    if previousFocusedWindow ~= nil then
        mousePositions[previousFocusedWindow:id()] = hs.mouse.absolutePosition()
    end

    hs.application.launchOrFocusByBundleID(appBundleID)

    -- 获取 application 对象
    local applications = hs.application.applicationsForBundleID(appBundleID)
    local application = nil
    for k, v in ipairs(applications) do
        application = v
    end

    local currentFocusedWindow = application:focusedWindow()
    if currentFocusedWindow ~= nil and mousePositions[currentFocusedWindow:id()] ~= nil then
        hs.mouse.absolutePosition(mousePositions[currentFocusedWindow:id()])
    else
        setMouseToCenter(currentFocusedWindow)
    end
end

function setMouseToCenter(foucusedWindow)
    if foucusedWindow == nil then
        return
    end
    local frame = foucusedWindow:frame()
    local centerPosition = hs.geometry.point(frame.x + frame.w / 2, frame.y + frame.h / 2)
    hs.mouse.absolutePosition(centerPosition)
end
