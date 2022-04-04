-- 应用切换

require 'modules.shortcut'

hs.fnutils.each(applications, function(item)
    hs.hotkey.bind(item.prefix, item.key, item.message, function()
        toggleAppByBundleId(item.bundleId)
    end)
end)

-- 鼠标位置
mousePositions = {}

function toggleAppByBundleId(appBundleID)
    -- 获取当前最靠前的应用,保存鼠标位置
    local frontMostApp = hs.application.frontmostApplication()
    -- 当前无最靠前的应用窗口或最靠前的应用的窗口
    if frontMostApp ~= nil and frontMostApp:mainWindow() ~= nil then
        mousePositions[frontMostApp:mainWindow():id()] = hs.mouse.absolutePosition
    end

    -- 两者重复时,寻找下一个该窗口
    if frontMostApp:bundleID() == appBundleID then
        local wf = hs.window.filter.new{frontMostApp:name()}
        local locT = wf:getWindows({hs.window.filter.sortByFocusedLast})
        if locT and #locT > 1 then
            local windowId = frontMostApp:mainWindow():id()
            for _, value in pairs(locT) do
                if value:id() ~= windowId then
                    value:focus()
                end
            end
        else
            frontMostApp:hide()
        end
    else
        -- 不存在窗口时,启动app
        local launchResult = hs.application.launchOrFocusByBundleID(appBundleID)
        if not launchResult then
            return
        end
    end
    -- 调整鼠标位置
    frontMostApp = hs.application.applicationsForBundleID(appBundleID)[1]
    local point = mousePositions[appBundleID]
    if point then
      hs.mouse.setAbsolutePosition(point)
      local currentSc = hs.mouse.getCurrentScreen()
      local tempSc = frontMostApp:mainWindow():screen()
      if currentSc ~= tempSc then
          setMouseToCenter(frontMostApp)
      end
    -- 找不到则转移到该屏幕中间
    else
        setMouseToCenter(frontMostApp)
    end
end

function setMouseToCenter(frontMostApp)
    local mainWindow = frontMostApp:mainWindow()
    if not mainWindow then
        return
    end
    local mainFrame = mainWindow:frame()
    local mainPoint = hs.geometry.point(mainFrame.x + mainFrame.w /2, mainFrame.y + mainFrame.h /2)
    hs.mouse.absolutePosition(mainPoint)
end
