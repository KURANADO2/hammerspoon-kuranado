-- 展示本工程快捷键列表

require 'modules.base'

local screen = hs.window.focusedWindow():screen():frame()

local COORIDNATE_X = screen.w / 2
local COORIDNATE_Y = screen.h / 2

-- 快捷键总数
local num = 0

-- 创建 Canvas
local canvas = hs.canvas.new({x = 0, y = 0, w = 0, h = 0})

-- TODO-JING 增加圆角
-- 背景面板
canvas:appendElements({
    id = 'pannel',
    action = 'fill',
    fillColor = {alpha = 0.9, red = 0, green = 0, blue = 0},
    type = 'rectangle'
})

function formatText()
    
    -- 加载所有绑定的快捷键
    local hotkeys = hs.hotkey.getHotkeys()
    local renderText = {}

    -- 每行最多 40 个字符
    local MAX_LEN = 40

    -- 文本定长
    for k, v in ipairs(hotkeys) do
        num = num + 1
        local msg = v.msg
        local len = utf8len(msg)
        -- 超过最大长度，截断多余部分，截断的部分作为新的一行
        while len > MAX_LEN do
            local substr = utf8sub(msg, 1, MAX_LEN)
            table.insert(renderText, {line = substr})
            msg = utf8sub(msg, MAX_LEN + 1, len)
            len = utf8len(msg)
        end
        for i = 1, MAX_LEN - utf8len(msg), 1 do
            msg = msg .. ' '
        end
        table.insert(renderText, {line = msg})
    end
    return renderText
end

function drawText(renderText)
    -- 每列最多 20 行
    local MAX_LINE_NUM = 20
    local w = 0
    local h = 0
    -- 文本距离分割线的距离
    local SEPRATOR_W = 5;

    -- 每一列需要显示的文本
    local column = ''
    for k, v in ipairs(renderText) do
        local line = v.line
        column = column .. line .. '  \n'
        -- k mod MAX_LINE_NUM
        if math.fmod(k, MAX_LINE_NUM) == 0 then
            local itemText = styleText(column)
            local size = canvas:minimumTextSize(itemText)
            -- 多 text size w 累加
            w = w + size.w
            if k == MAX_LINE_NUM then
                h = size.h
            end
            canvas:appendElements({
                type = 'text',
                text = itemText,
                frame = {x = (k / MAX_LINE_NUM - 1) * size.w + SEPRATOR_W, y = 0, w = size.w + SEPRATOR_W, h = size.h}
            })
            canvas:appendElements({ 
                type = "segments", 
                closed = false, 
                -- strokeColor = { blue = 1 }, 
                strokeColor = { hex = '#0096FA' },
                action = "stroke",
                strokeWidth = 2,
                coordinates = {{ x = (k / MAX_LINE_NUM) * size.w - SEPRATOR_W, y = 0 }, {x = (k / MAX_LINE_NUM) * size.w - SEPRATOR_W, y = h}},
            })
            column = ''
        end
    end
    if column ~= nil then
        local itemText = styleText(column)
        local size = canvas:minimumTextSize(itemText)
        w = w + size.w
        canvas:appendElements({
            type = 'text',
            text = itemText,
            frame = {x = math.ceil(num / MAX_LINE_NUM - 1) * size.w + SEPRATOR_W, y = 0, w = size.w + SEPRATOR_W, h = size.h}
        })
        column = nil
    end
    
    -- 居中显示
    canvas:frame({x = COORIDNATE_X - w / 2, y = COORIDNATE_Y - h / 2, w = w, h = h})
end

function styleText(text)
    return hs.styledtext.new(text, {
        font = {
            name = "Monaco",
            size = 14
        },
        color = {hex = '#0096FA'},
        paragraphStyle = {
            lineSpacing = 5
        }
    })
end

-- 默认不显示
local show = false

-- toggle show/hide
function toggleHotkeysShow()
    if show then
        -- 0.3s 过渡
        canvas:hide(.3)
    else 
        -- 0.3s 过渡
        canvas:show(.3)
    end
    show = not show
end

function closeHotKeyShow()
    canvas:hide(.3)
    show = false
end

drawText(formatText())

-- ⌥/ 显示/隐藏快捷键列表
hs.hotkey.bind({ 'alt' }, '/', toggleHotkeysShow)
-- Esc 关闭快捷键列表（仅在快捷键列表已显示情况下生效）
-- hs.hotkey.bind({'zero'}, 'escape',  closeHotKeyShow)