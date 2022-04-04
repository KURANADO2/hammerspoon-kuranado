-- 窗口管理

require 'modules.shortcut'

-- 关闭动画持续时间
hs.window.animationDuration = 0

-- 窗口移动
-- 左半屏
hs.hotkey.bind(windows.left.prefix, windows.left.key, windows.left.message, function()
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
hs.hotkey.bind(windows.right.prefix, windows.right.key, windows.right.message, function()
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
hs.hotkey.bind(windows.up.prefix, windows.up.key, windows.up.message, function()
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
hs.hotkey.bind(windows.down.prefix, windows.down.key, windows.down.message, function()
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
hs.hotkey.bind(windows.top_left.prefix, windows.top_left.key, windows.top_left.message, function()
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
hs.hotkey.bind(windows.top_right.prefix, windows.top_right.key, windows.top_right.message, function()
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
hs.hotkey.bind(windows.left_bottom.prefix, windows.left_bottom.key, windows.left_bottom.message, function()
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
hs.hotkey.bind(windows.right_bottom.prefix, windows.right_bottom.key, windows.right_bottom.message, function()
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
hs.hotkey.bind(windows.one.prefix, windows.one.key, windows.one.message, function()
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
hs.hotkey.bind(windows.two.prefix, windows.two.key, windows.two.message, function()
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
hs.hotkey.bind(windows.three.prefix, windows.three.key, windows.three.message, function()
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
hs.hotkey.bind(windows.four.prefix, windows.four.key, windows.four.message, function()
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
hs.hotkey.bind(windows.five.prefix, windows.five.key, windows.five.message, function()
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
hs.hotkey.bind(windows.six.prefix, windows.six.key, windows.six.message, function()
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
hs.hotkey.bind(windows.seven.prefix, windows.seven.key, windows.seven.message, function()
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
hs.hotkey.bind(windows.eight.prefix, windows.eight.key, windows.eight.message, function()
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
hs.hotkey.bind(windows.nine.prefix, windows.nine.key, windows.nine.message, function()
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
hs.hotkey.bind(windows.left_1_3.prefix, windows.left_1_3.key, windows.left_1_3.message, function()
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
hs.hotkey.bind(windows.middle.prefix, windows.middle.key, windows.middle.message, function()
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
hs.hotkey.bind(windows.right_1_3.prefix, windows.right_1_3.key, windows.right_1_3.message, function()
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
hs.hotkey.bind(windows.left_2_3.prefix, windows.left_2_3.key, windows.left_2_3.message, function()
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
hs.hotkey.bind(windows.right_2_3.prefix, windows.right_2_3.key, windows.right_2_3.message, function()
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
hs.hotkey.bind(windows.center.prefix, windows.center.key, windows.center.message, function()
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
hs.hotkey.bind(windows.zoom.prefix, windows.zoom.key, windows.zoom.message, function()
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
hs.hotkey.bind(windows.narrow.prefix, windows.narrow.key, windows.narrow.message, function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    f.w = f.w - 40
    f.h = f.h - 40
    f.x = f.x + 20
    f.y = f.y + 20
    win:setFrame(f)
end)

-- 最大化
hs.hotkey.bind(windows.max.prefix, windows.max.key, windows.max.message, function()
    local win = hs.window.focusedWindow()
    win:maximize()
end)

-- 将窗口移动到上方屏幕
hs.hotkey.bind(windows.to_up.prefix, windows.to_up.key, windows.to_up.message, function()
    local win = hs.window.focusedWindow()
    if (win) then
        win:moveOneScreenNorth()
    end
end)

-- 将窗口移动到下方屏幕
hs.hotkey.bind(windows.to_down.prefix, windows.to_down.key, windows.to_down.message, function()
    local win = hs.window.focusedWindow()
    if (win) then
        win:moveOneScreenSouth()
    end
end)

-- 将窗口移动到左侧屏幕
hs.hotkey.bind(windows.to_left.prefix, windows.to_left.key, windows.to_left.message, function()
    local win = hs.window.focusedWindow()
    if (win) then
        win:moveOneScreenWest()
    end
end)

-- 将窗口移动到右侧屏幕
hs.hotkey.bind(windows.to_right.prefix, windows.to_right.key, windows.to_right.message, function()
    local win = hs.window.focusedWindow()
    if (win) then
        win:moveOneScreenEast()
    end
end)