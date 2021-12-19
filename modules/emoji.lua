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

obj = {}

function request(choices, query)

    keyword, page = parse_query(query)

    print('keyword:', keyword)
    print('page:', page)

    if keyword == nil or page == nil then
        return
    end

    local url = api .. hs.http.encodeForQuery(keyword) .. '&page=' .. page .. '&size=9'
    -- print('url:', url)

    hs.http.doAsyncRequest(url, 'GET', nil, request_headers, function(code, body, response_headers)
        print('body:', body)
        rawjson = hs.json.decode(body)
        if code == 200 and rawjson.code == 1000 then
            obj.len = #rawjson.data
            for k, v in ipairs(rawjson.data) do
                -- TODO-JING 支持异步下载
                -- 下载图片
                local file_path = download_file(v.url)
                table.insert(choices, {
                    text = v.title,
                    subText = v.url,
                    -- 加载图片
                    image = hs.image.imageFromPath(file_path),
                    path = file_path
                })
            end
            chooser:choices(choices)
        end
    end)
end

function parse_query(query)
    local k = ''
    local p = nil
    if query == nil or query == '' then
        return nil, nil
    end
    query = trim(query)
    -- 按照空格切割
    arr = split(query, ' ')

    if #arr == 1 then
        k = arr[1]
        p = 1
    end

    -- 最后一项是否为数字
    if string.find(arr[#arr], '[0-9]+', 1) == nil then
        p = 1
    else 
        p = tonumber(arr[#arr])
    end
    for i = 1, #arr - 1 do
        k = k .. arr[i]
    end
    if trim(k) == '' then
        return nil, nil
    end
    return k, p
end

function download_file(url)
    local kurl = hs.http.urlParts(url)
    local file_path = cache_dir .. kurl.lastPathComponent
    if not file_exists(file_path) then
        hs.execute('curl --header \'Referer: http://kuranado.com\' --request GET ' .. url .. ' --create-dirs -o ' .. file_path)
    end
    return file_path
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

-- TODO-JING 增加延时
chooser:queryChangedCallback(function()
    local query = chooser:query()
    choices = {}
    request(choices, query)
end)

chooser:hideCallback(function()
    canvas:hide(.3)
end)

-- 上下键选择表情包预览
key = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    -- 只在 chooser 显示时，才监听键盘按下
    if not chooser:isVisible() then
        return
    end
    local keycode = event:getKeyCode()
    local key = hs.keycodes.map[keycode]
    if 'down' ~= key and 'up' ~= key then
        return
    end
    -- TODO-JING 第一项需要直接预览
    number = chooser:selectedRow()
    if 'down' == key then
        if number < obj.len then
            number = number + 1
        else 
            number = 1
        end
    end
    if 'up' == key then
        if number > 1 then
            number = number - 1
        else
            number = obj.len
        end
    end
    row_contents = chooser:selectedRowContents(number)
    preview(row_contents.path)
end):start()

function preview(path)
    canvas[1] = {
        type = 'image',
        image = hs.image.imageFromPath(path),
        imageScaling = 'scaleToFit',
        imageAnimates = true
    }
    canvas:show()
end

hs.hotkey.bind({"alt"}, "K", function()
    chooser:show()
end)