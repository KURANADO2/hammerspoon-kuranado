-- 表情包搜索

require 'modules.base'

local screen = hs.window.focusedWindow():screen():frame()

-- 占屏幕宽度的 20%（居中）
local WIDTH = 300
local HEIGHT = 300
local CHOOSER_WIDTH = screen.w * .2
local COORIDNATE_X = screen.w / 2 + CHOOSER_WIDTH / 2 + 5
local COORIDNATE_Y = screen.h / 2 - 300
canvas = hs.canvas.new({x = COORIDNATE_X, y = COORIDNATE_Y - HEIGHT / 2, w = WIDTH, h = HEIGHT})

api = "http://api.kuranado.com/emoji/search?keyword="
request_headers = {Referer = 'http://kuranado.com'}
cache_dir = os.getenv("HOME") .. '/.hammerspoon/.emoji/'

choices = {}
page = 1

chooser = hs.chooser.new(function(choice)
    if not choice then
        return
    end
    -- 回车选择的表情包
    -- 复制文件到剪贴板
    local script = string.gsub('osascript -e \'tell app "Finder" to set the clipboard to ( POSIX file "{}")\'', '{}', choice['path'], 1)
    -- 不知为何，下面的脚本不生效，shell 脚本却是可以的
    -- local script = string.gsub('osascript -e \'set the clipboard to POSIX file ("{}")\' return the clipboard', '{}', path, 1)
    hs.execute(script)
    -- 直接粘贴
    hs.eventtap.keyStroke({'cmd'}, 'v')
end)
chooser:width(20)
chooser:rows(10)
chooser:bgDark(false)
chooser:fgColor({
    hex = '#000000'
})
chooser:placeholderText('搜索表情包')

function request(query)

    choices = {}

    if query == nil or trim(query) == '' then
        return
    end

    local url = api .. hs.http.encodeForQuery(query) .. '&page=' .. page .. '&size=9'
    print('url:', url)

    hs.http.doAsyncRequest(url, 'GET', nil, request_headers, function(code, body, response_headers)
        rawjson = hs.json.decode(body)
        if code == 200 and rawjson.code == 1000 then
            len = #rawjson.data
            for k, v in ipairs(rawjson.data) do
                local file_path = cache_dir .. hs.http.urlParts(v.url).lastPathComponent
                -- 下载图片
                download_file(v.url, file_path)
                table.insert(choices, {
                    text = v.title,
                    subText = v.url,
                    path = file_path,
                    image = hs.image.imageFromPath(file_path)
                })
            end
            chooser:choices(choices)
        end
    end)
end

function download_file(url, file_path)
    if not file_exists(file_path) then
        -- 同步方式下载
        -- hs.execute('curl --header \'Referer: http://kuranado.com\' --request GET ' .. url .. ' --create-dirs -o ' .. file_path)
        -- 异步方式下载
        hs.task.new('/usr/bin/curl', async_download_callback, {'--header', 'Referer: http://kuranado.com', url, '--create-dirs', '-o', file_path}):start()
    end
end

function async_download_callback(exitCode, stdOut, stdErr)
    local len = #choices
    if len == 0 then
        return
    end
    -- 下载完一张图片，就刷新整个列表（不得已而为之）
    for i = 1, len do
        if choices[i].path ~= nil then
            choices[i].image = hs.image.imageFromPath(choices[i].path)
        end
    end
    chooser:choices(choices)
end

function file_exists(file_path)
    local f = io.open(file_path,"r")
    if f ~= nil then
        io.close(f)
        return true
    else 
        return false
    end
 end

function preview(path)
    canvas[1] = {
        type = 'image',
        image = hs.image.imageFromPath(path),
        imageScaling = 'scalePropertionally',
        imageAnimates = true
    }
    canvas:show()
end

-- 上下键选择表情包预览
key = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    -- 只在 chooser 显示时，才监听键盘按下
    if not chooser:isVisible() then
        return
    end
    local keycode = event:getKeyCode()
    local key = hs.keycodes.map[keycode]
    if 'right' == key then
        page = page + 1
        request(chooser:query())
        return
    end
    if 'left' == key then
        if page <= 1 then
            page = 1
            return
        end
        page = page - 1
        request(chooser:query())
        return
    end
    
    if 'down' ~= key and 'up' ~= key then
        return
    end
    -- TODO-JING 第一项需要直接预览
    number = chooser:selectedRow()
    if 'down' == key then
        if number < len then
            number = number + 1
        else 
            number = 1
        end
    end
    if 'up' == key then
        if number > 1 then
            number = number - 1
        else
            number = len
        end
    end
    row_contents = chooser:selectedRowContents(number)
    preview(row_contents.path)
end):start()

hs.hotkey.bind({"alt"}, "K", function()
    page = 1
    chooser:query('')
    chooser:show()
end)

-- TODO-JING 增加延时
chooser:queryChangedCallback(function()
    local query = chooser:query()
    print('query:', query)
    page = 1
    request(query)
end)

chooser:hideCallback(function()
    canvas:hide(.3)
end)

-- TODO-JING 解决中文输入法界面被遮挡问题
-- TODO-JING 解决每次搜索卡顿问题