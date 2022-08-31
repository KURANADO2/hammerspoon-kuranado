-- 按键显示
local screen = hs.screen.mainScreen():frame()
local COORIDNATE_X = 30
local COORIDNATE_Y = screen.h - 40
-- 画布最大宽度
local WIDTH = screen.w - 60
-- print('WIDTH：', WIDTH)
local canvas_w = 0
local canvas_h = 0
-- 1 s 内键入下一个字符，则在当前画布上继续追加字符，1 s 后键入下一个字符，则清空字符后重新开始添加
local interval = 0.5 * 1000
-- 当前画布的最后一个字符输入后，展示 1.5 s 后开始淡出画布，画布淡出后立即删除画布
local duration = 1.5 * 1000
-- 淡出画布的动画时间
local fade_out = 0.3

local keycodes = {
    kctrl = { char = "⌃", duplicate_removal = true, first = true },
    krightctrl = { char = "⌃", duplicate_removal = true, first = true },
    kalt = { char = "⌥", duplicate_removal = true, first = true },
    krightalt = { char = "⌥", duplicate_removal = true, first = true },
    kcmd = { char = "⌘", duplicate_removal = true, first = true },
    krightcmd = { char = "⌘", duplicate_removal = true, first = true },
    kshift = { char = "⇧", duplicate_removal = true, first = true },
    krightshift = { char = "⇧", duplicate_removal = true, first = true },
    ktab = { char = "⇥", duplicate_removal = false, first = true },
    kcapslock = { char = "⇪", duplicate_removal = true, first = true },
    kup = { char = "↑", duplicate_removal = false },
    kdown = { char = "↓", duplicate_removal = false },
    kleft = { char = "←", duplicate_removal = false },
    kright = { char = "→", duplicate_removal = false },
    kescape = { char = "⎋", duplicate_removal = false },
    kforwarddelete = { char = "⌦", duplicate_removal = false },
    kdelete = { char = "⌫", duplicate_removal = false },
    khome = { char = "↖︎", duplicate_removal = false },
    kend = { char = "↘︎", duplicate_removal = false },
    kpageup = { char = "⇞", duplicate_removal = false },
    kpagedown = { char = "⇟", duplicate_removal = false },
    kspace = { char = "␣", duplicate_removal = false },
    kreturn = { char = "↩︎", duplicate_removal = false },
    kfn = { char = "fn", duplicate_removal = false },
}

visualizer_key = hs.eventtap
    .new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.flagsChanged }, function(event)
        local keycode = event:getKeyCode()
        if keycode == 255 or keycode == 179 then
            goto continue
        end
        local key = hs.keycodes.map[keycode]
        local tmp = keycodes["k" .. key]
        if tmp ~= nil then
            if tmp.duplicate_removal then
                if tmp.first then
                    tmp.first = false
                else
                    tmp.first = true
                    goto continue
                end
            end
            key = tmp.char
        end
        -- 渲染
        render(key)
        ::continue::
    end)
    :start()

-- 当前画布属性
local ele = {
    -- 展示的文本
    text = "",
    -- 画布行数
    line_number = 0,
    -- 是否为画布第一行
    first_line = true,
    -- 画布接收到上一个字符的时间
    last_time = 0,
    -- 是否为画布接收到的第一个字符
    first_key = true,
    -- 画布
    canvas = hs.canvas.new({
        x = 0,
        y = 0,
        w = 0,
        h = 0,
    }),
}

function render(key)
    local now_time = now()

    if ele.first_key then
        ele.last_time = now_time
        ele.first_key = false
    end

    -- 0.5 s 内键入下一个字符
    if now_time - ele.last_time <= interval then
        -- 在当前画布上追加字符
        ele.text = ele.text .. key
    else
        -- 重新初始化画布属性
        ele.text = key
        ele.line_number = 0
        ele.first_line = true
        ele.last_time = 0
        ele.first_key = true
    end

    local itemText = styleKeystrokeText(ele.text)
    -- 文本大小
    local size = ele.canvas:minimumTextSize(itemText)
    ele.line_number = math.ceil(size.w / WIDTH)
    -- 若文本宽度超过最大宽度，则需要扩大画布高度
    if size.w > WIDTH then
        -- 文本宽度第一次超过画布最大宽度，此时扩充画布最大宽度等于当前文本宽度
        if ele.first_line then
            WIDTH = size.w
            ele.first_line = false
        end
        canvas_w = WIDTH
        -- 高度加一行
        canvas_h = ele.line_number * size.h
    else
        canvas_w = size.w
        canvas_h = size.h
    end
    ele.canvas[1] = {
        id = "text",
        type = "text",
        text = itemText,
    }

    ele.canvas:frame({
        x = COORIDNATE_X,
        y = COORIDNATE_Y - (ele.line_number - 1) * size.h,
        w = canvas_w,
        h = canvas_h,
    })
    ele.canvas:show()
    ele.last_time = now_time
end

function hideCanvas()
    if now() - ele.last_time > duration then
        ele.canvas:hide(fade_out)
    end
end

function now()
    -- 精确到毫秒（Lua os.time() 只能精确到秒）
    return hs.timer.secondsSinceEpoch() * 1000
end

function styleKeystrokeText(text)
    return hs.styledtext.new(text, {
        font = {
            name = "Monaco",
            size = 40,
        },
        -- 加粗
        strokeWidth = -5,
        color = {
            hex = "#ffffff",
        },
        backgroundColor = {
            hex = "#000000",
            alpha = 0.5,
        },
        paragraphStyle = {
            -- 超过画布宽度后自动换行
            lineBreak = "wordWrap",
        },
    })
end

ktimer = hs.timer.doEvery(5, hideCanvas, true):start()
