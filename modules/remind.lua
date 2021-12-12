-- 提醒休息等功能

-- 下班
local screen = hs.window.focusedWindow():screen():frame()

local COORIDNATE_X = screen.w / 2
local COORIDNATE_Y = screen.h / 2
local WIDTH = 300
local HEIGHT = 300

-- 清除 Canvas
function cleanCanvas(c)
    if c ~= nil then
        -- 渐出
        c:hide(.3)
        -- 渐出动画执行完后在删除 Canvas
        hs.timer.doAfter(1, function()
            c:delete()
            c = nil
        end)
    end
end

-- 下班提醒
function afterWork()
    local canvas = hs.canvas.new({x = COORIDNATE_X - WIDTH / 2, y = COORIDNATE_Y - HEIGHT / 2, w = WIDTH, h = HEIGHT})
    canvas:appendElements({
        id = 'after-work',
        type = 'image',
        image = hs.image.imageFromPath(os.getenv("HOME") .. '/.hammerspoon/images/after-work.gif'),
        imageScaling = 'scaleToFit',
        imageAnimates = true
    })
    -- 渐入
    canvas:show(.3)
    -- 绑定鼠标点击事件
    local c = canvas:canvasMouseEvents(true, nil, nil, nil)
    -- 点击回调，清除 Canvas
    local d = canvas:mouseCallback(function ()
        cleanCanvas(c)
    end)
end

-- 调用下班动画
-- afterWork()

-- 每天 18:00 提醒下班
kstart = hs.timer.doAt('18:00', hs.timer.days(1), afterWork):start()
-- 1 分钟后清除 Canvas
-- kend = hs.timer.doAt('18:01', hs.timer.days(1), cleanCanvas):start()
