-- Reload config when the file changes
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

-- 设置显示器（显示器名称可通过在 Hammerspoon Console 控制台中输入 hs.screen.allScreens()[1]:name() 和 hs.screen.allScreens()[2]:name() 得到，更多显示器依次类推）
-- 获取显示器数目
local monitor_num = #hs.screen.allScreens()
-- 设置主显示器
local main_monitor = hs.screen.allScreens()[1]:id()
-- 设置副显示器
local second_monitor = nil
if (monitor_num >= 2)
then
    second_monitor = hs.screen.allScreens()[2]:id()
end
-- 设置第三个显示器（暂未使用）
local thrid_monitor = nil
if (monitor_num >= 3)
then
    thrid_monitor = hs.screen.allScreens()[3]:id()
end
-- 设置第四个显示器（暂未使用）
local fourth_monitor = nil
if (monitor_num >= 4)
then
    fourth_monitor = hs.screen.allScreens()[4]:id()
end

-- 关闭动画持续时间
hs.window.animationDuration = 0

-- 窗口移动
-- 左半屏
hs.hotkey.bind({"alt", "ctrl"}, "Left", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end)

-- 右半屏
hs.hotkey.bind({"alt", "ctrl"}, "Right", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end)

-- 上半屏
hs.hotkey.bind({"alt", "ctrl"}, "Up", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h / 2
    win:setFrame(f)
end)

-- 下半屏
hs.hotkey.bind({"alt", "ctrl"}, "Down", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y + (max.h / 2)
    f.w = max.w
    f.h = max.h / 2
    win:setFrame(f) 
end)

-- 左上角
hs.hotkey.bind({"alt", "ctrl"}, "U", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)

-- 右上角
hs.hotkey.bind({"alt", "ctrl"}, "I", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)

-- 左下角
hs.hotkey.bind({"alt", "ctrl"}, "J", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y + (max.h / 2)
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)

-- 右下角
hs.hotkey.bind({"alt", "ctrl"}, "K", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y + (max.h / 2)
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)

-- 1/9
hs.hotkey.bind({"alt", "ctrl"}, "1", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 3
    f.h = max.h / 3
    win:setFrame(f)
end)

-- 2/9
hs.hotkey.bind({"alt", "ctrl"}, "2", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 3)
    f.y = max.y
    f.w = max.w / 3
    f.h = max.h / 3
    win:setFrame(f)
end)

-- 3/9
hs.hotkey.bind({"alt", "ctrl"}, "3", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 3) * 2
    f.y = max.y
    f.w = max.w / 3
    f.h = max.h / 3
    win:setFrame(f)
end)

-- 4/9
hs.hotkey.bind({"alt", "ctrl"}, "4", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y + (max.h / 3)
    f.w = max.w / 3
    f.h = max.h / 3
    win:setFrame(f)
end)

-- 5/9
hs.hotkey.bind({"alt", "ctrl"}, "5", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 3)
    f.y = max.y + (max.h / 3)
    f.w = max.w / 3
    f.h = max.h / 3
    win:setFrame(f)
end)

-- 6/9
hs.hotkey.bind({"alt", "ctrl"}, "6", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 3) * 2
    f.y = max.y + (max.h / 3)
    f.w = max.w / 3
    f.h = max.h / 3
    win:setFrame(f)
end)

-- 7/9
hs.hotkey.bind({"alt", "ctrl"}, "7", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y + (max.h / 3) * 2
    f.w = max.w / 3
    f.h = max.h / 3
    win:setFrame(f)
end)

-- 8/9
hs.hotkey.bind({"alt", "ctrl"}, "8", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 3)
    f.y = max.y + (max.h / 3) * 2
    f.w = max.w / 3
    f.h = max.h / 3
    win:setFrame(f)
end)

-- 9/9
hs.hotkey.bind({"alt", "ctrl"}, "9", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 3) * 2
    f.y = max.y + (max.h / 3) * 2
    f.w = max.w / 3
    f.h = max.h / 3
    win:setFrame(f)
end)

-- 左 1/3（横屏）或上 1/3（竖屏）
hs.hotkey.bind({"alt", "ctrl"}, "D", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    -- 如果为竖屏
    if (isVerticalScreen(screen)) then
        f.x = max.x
        f.y = max.y
        f.w = max.w
        f.h = max.h / 3
        -- 如果为横屏
    else
        f.x = max.x
        f.y = max.y
        f.w = max.w / 3
        f.h = max.h
    end
    win:setFrame(f)
end)

-- 中 1/3
hs.hotkey.bind({"alt", "ctrl"}, "F", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    -- 如果为竖屏
    if (isVerticalScreen(screen)) then
        f.x = max.x
        f.y = max.y + (max.h / 3)
        f.w = max.w
        f.h = max.h / 3
        -- 如果为横屏
    else
        f.x = max.x + (max.w / 3)
        f.y = max.y
        f.w = max.w / 3
        f.h = max.h
    end
    win:setFrame(f)
end)

-- 右 1/3（横屏）或下 1/3（竖屏）
hs.hotkey.bind({"alt", "ctrl"}, "G", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    -- 如果为竖屏
    if (isVerticalScreen(screen)) then
        f.x = max.x
        f.y = max.y + (max.h / 3 * 2)
        f.w = max.w
        f.h = max.h / 3
        -- 如果为横屏
    else
        f.x = max.x + (max.w / 3 * 2)
        f.y = max.y
        f.w = max.w / 3
        f.h = max.h
    end
    win:setFrame(f)
end)

-- 左 2/3（横屏）或上 2/3（竖屏）
hs.hotkey.bind({"alt", "ctrl"}, "E", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    -- 如果为竖屏
    if (isVerticalScreen(screen)) then
        f.x = max.x
        f.y = max.y
        f.w = max.w
        f.h = max.h / 3 * 2
        -- 如果为横屏
    else
        f.x = max.x
        f.y = max.y
        f.w = max.w / 3 * 2
        f.h = max.h
    end
    win:setFrame(f)
end)

-- 右 2/3（横屏）或下 2/3（竖屏）
hs.hotkey.bind({"alt", "ctrl"}, "T", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    -- 如果为竖屏
    if (isVerticalScreen(screen)) then
        f.x = max.x
        f.y = max.y + (max.h / 3)
        f.w = max.w
        f.h = max.h / 3 * 2
        -- 如果为横屏
    else
        f.x = max.x + (max.w / 3)
        f.y = max.y
        f.w = max.w / 3 * 2
        f.h = max.h
    end
    win:setFrame(f)
end)

-- 判断指定屏幕是否为竖屏
function isVerticalScreen(screen)
    if (screen:rotate() == 90 or screen:rotate() == 270) then
        return true
    else
        return false
    end
end

-- 居中
hs.hotkey.bind({"alt", "ctrl"}, "C", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 4)
    f.y = max.y + (max.h / 4)
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)

-- 等比例放大窗口
hs.hotkey.bind({"alt", "ctrl"}, "=", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = f.w + 40
    f.h = f.h + 40
    f.x = f.x - 20
    f.y = f.y - 20
    if (f.x < max.x) then
        f.x = max.x
    end
    if (f.y < max.y) then
        f.y = max.y
    end
    if (f.w > max.w) then
        f.w = max.w
    end
    if (f.h > max.h) then
        f.h = max.h
    end
    win:setFrame(f)
end)

-- 等比例缩小窗口
hs.hotkey.bind({"alt", "ctrl"}, "-", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    f.w = f.w - 40
    f.h = f.h - 40
    f.x = f.x + 20
    f.y = f.y + 20
    win:setFrame(f)
end)

-- 最大化
hs.hotkey.bind({"alt", "ctrl"}, "Return", function()
    local win = hs.window.focusedWindow()
    win:maximize()
end)

-- 主屏副屏之间的窗口移动（适用于主屏物理位置在右，副屏物理位置在左的显示器摆放布局，若不是该布局，则在系统偏好设置 -> 显示器 -> 排列下，将白色的条块拖动到右边的显示器顶部）
-- 主屏窗口移动到副屏
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
    local win = hs.window.focusedWindow()
    if (win) then
        win:moveToScreen(second_monitor)
    end
end)

-- 副屏窗口移动到主屏
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
    local win = hs.window.focusedWindow()
    if (win) then
        win:moveToScreen(main_monitor)
    end
end)

-- 应用切换
hs.hotkey.bind({ "alt" }, "q", function()
    toggleAppByBundleId("com.tencent.qq")
end)
hs.hotkey.bind({ "alt" }, "w", function()
    toggleAppByBundleId("com.tencent.xinWeChat")
end)
hs.hotkey.bind({ "alt" }, "v", function()
    toggleAppByBundleId("com.microsoft.VSCode")
end)
hs.hotkey.bind({ "alt" }, "f", function()
    toggleAppByBundleId("com.apple.finder")
end)
hs.hotkey.bind({ "alt" }, "c", function()
    toggleAppByBundleId("com.google.Chrome")
end)
hs.hotkey.bind({ "alt" }, "j", function()
    toggleAppByBundleId("com.jetbrains.intellij")
end)
hs.hotkey.bind({ "alt" }, "n", function()
    toggleAppByBundleId("cn.wiz.wiznoteformac")
end)
hs.hotkey.bind({ "alt" }, "g", function()
    toggleAppByBundleId("com.electron.gridea")
end)
hs.hotkey.bind({ "alt" }, "d", function()
    toggleAppByBundleId("com.jetbrains.datagrip")
end)
hs.hotkey.bind({ "alt" }, "t", function()
    toggleAppByBundleId("com.googlecode.iterm2")
end)
hs.hotkey.bind({ "alt" }, "m", function()
    toggleAppByBundleId("com.netease.macmail")
end)
hs.hotkey.bind({ "alt" }, "p", function()
    toggleAppByBundleId("com.postmanlabs.mac")
end)
hs.hotkey.bind({ "alt" }, "o", function()
    toggleAppByBundleId("com.microsoft.Word")
end)
hs.hotkey.bind({ "alt" }, "e", function()
    toggleAppByBundleId("com.microsoft.Excel")
end)
hs.hotkey.bind({ "alt" }, "s", function()
    toggleAppByBundleId("com.vandyke.SecureCRT")
end)
hs.hotkey.bind({ "alt" }, "y", function()
    toggleAppByBundleId("com.jetbrains.pycharm")
end)
hs.hotkey.bind({ "alt" }, "r", function()
    toggleAppByBundleId("me.qii404.another-redis-desktop-manager")
end)

-- 鼠标位置
mousePositions = {}

function toggleAppByBundleId(appBundleID)
    -- 获取当前最靠前的应用,保存鼠标位置
    local frontMostApp = hs.application.frontmostApplication()
    -- 当前无最靠前的应用（没有任何应用获取到鼠标焦点，此种情况在发生在）
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
