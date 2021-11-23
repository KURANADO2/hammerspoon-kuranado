-- 应用切换
hs.hotkey.bind({ "alt" }, "q", "QQ", function()
    toggleAppByBundleId("com.tencent.qq")
end)
hs.hotkey.bind({ "alt" }, "w", "WeChat", function()
    toggleAppByBundleId("com.tencent.xinWeChat")
end)
hs.hotkey.bind({ "alt" }, "v", "VSCode", function()
    toggleAppByBundleId("com.microsoft.VSCode")
end)
hs.hotkey.bind({ "alt" }, "f", "Finder", function()
    toggleAppByBundleId("com.apple.finder")
end)
hs.hotkey.bind({ "alt" }, "c", "Chrome", function()
    toggleAppByBundleId("com.google.Chrome")
end)
hs.hotkey.bind({ "alt" }, "j", "IntelliJ IDEA", function()
    toggleAppByBundleId("com.jetbrains.intellij")
end)
hs.hotkey.bind({ "alt" }, "n", "WizNote", function()
    toggleAppByBundleId("cn.wiznote.desktop")
end)
hs.hotkey.bind({ "alt" }, "g", "Gridea", function()
    toggleAppByBundleId("com.electron.gridea")
end)
hs.hotkey.bind({ "alt" }, "d", "DataGrip", function()
    toggleAppByBundleId("com.jetbrains.datagrip")
end)
hs.hotkey.bind({ "alt" }, "t", "iTerm2", function()
    toggleAppByBundleId("com.googlecode.iterm2")
end)
hs.hotkey.bind({ "alt" }, "m", "MailMaster", function()
    toggleAppByBundleId("com.netease.macmail")
end)
hs.hotkey.bind({ "alt" }, "p", "Postman", function()
    toggleAppByBundleId("com.postmanlabs.mac")
end)
hs.hotkey.bind({ "alt" }, "o", "Word", function()
    toggleAppByBundleId("com.microsoft.Word")
end)
hs.hotkey.bind({ "alt" }, "e", "Excel", function()
    toggleAppByBundleId("com.microsoft.Excel")
end)
hs.hotkey.bind({ "alt" }, "s", "SecureCRT", function()
    toggleAppByBundleId("com.vandyke.SecureCRT")
end)
hs.hotkey.bind({ "alt" }, "y", "PyCharm", function()
    toggleAppByBundleId("com.jetbrains.pycharm")
end)
hs.hotkey.bind({ "alt" }, "r", "Redis Desktop", function()
    toggleAppByBundleId("me.qii404.another-redis-desktop-manager")
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
