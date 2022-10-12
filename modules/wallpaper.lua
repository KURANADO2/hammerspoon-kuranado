require("modules.base")

BING_WALLPAPER_API =
    "https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=10&nc=1612409408851&pid=hp&FORM=BEHPTB&uhd=1&uhdwidth=3840&uhdheight=2160"
BING_DOMAIN = "https://cn.bing.com"
CACHE_DIR = os.getenv("HOME") .. "/.hammerspoon/.wallpaper/"

local function download_file(url, save_path)
    if not file_exists(save_path) then
        -- 异步下载
        local down_wallpaper_task =
            hs.task.new("/usr/bin/curl", async_download_callback, { url, "--create-dirs", "-o", save_path })
        down_wallpaper_task:start()
    end
end

local function async_download_callback(exitCode, stdOut, stdErr)
    -- 何もしない
    print("exitCode:", exitCode, "stdOut:", stdOut, "stdErr:", stdErr)
end

function get_save_path(dir, downloadable_path)
    local index = string.find(downloadable_path, "=")
    local filename = utf8sub(downloadable_path, index + 1, #downloadable_path)
    return dir .. filename
end

function get_bing_downloadable_url(downloadable_path)
    return BING_DOMAIN .. downloadable_path
end

function get_bing_downloadable_path(path)
    local index = string.find(path, "&")
    return utf8sub(path, 1, index - 1)
end

function download_wallpaper(dir)
    hs.http.asyncGet(BING_WALLPAPER_API, nil, function(code, body, _response_headers)
        rawjson = hs.json.decode(body)
        if code == 200 then
            len = #rawjson.images
            for k, v in ipairs(rawjson.images) do
                local downloadable_path = get_bing_downloadable_path(v.url)
                local downloadable_url = get_bing_downloadable_url(downloadable_path)
                -- 缓存到本地的目录
                local save_path = get_save_path(dir, downloadable_path)
                -- 下载图片到本地
                download_file(downloadable_url, save_path)
            end
        end
    end)
end

-- 列出指定目录下的壁纸
function list_wallpaper(dir)
    -- 如果壁纸目录不存在，则联网下载
    if not file_exists(dir) then
        download_wallpaper(dir)
        -- 第一次下载壁纸时不做壁纸切换，下次定时任务触发时再切换
        return nil
    end
    local wallpapers = {}
    for file in hs.fs.dir(dir) do
        if file ~= "." and file ~= ".." then
            table.insert(wallpapers, dir .. file)
        end
    end
    -- 对壁纸文件按照文件名 Ascii 码从小到大排序
    table.sort(wallpapers)
    return wallpapers
end

function format_today()
    return os.date("%Y-%m-%d")
end

function get_today_dir()
    return CACHE_DIR .. format_today() .. "/"
end

function switch_wallpaper()
    -- 列出今日壁纸
    local wallpapers = list_wallpaper(get_today_dir())
    if wallpapers == nil then
        return
    end
    -- 壁纸按照文件名称排序（不排也没关系，只是后续可能会基于排序后的壁纸来指定切换规则）
    table.sort(wallpapers)
    -- 拿到所有屏幕对象
    local screens = hs.screen.allScreens()
    for k, screen in ipairs(screens) do
        -- 为每个屏幕设置随机的壁纸
        screen:desktopImageURL("file://" .. wallpapers[math.random(1, #wallpapers)])
    end
end

function delete_wallpaper()
    local today_dir = get_today_dir()
    print("today_dir:", today_dir)
    for file in hs.fs.dir(CACHE_DIR) do
        if file ~= "." and file ~= ".." and file ~= format_today() then
            hs.fs.rmdir(CACHE_DIR .. file)
        end
    end
end

-- 手动调试时取消注释
-- switch_wallpaper()
-- delete_wallpaper()

-- 每 10 min 切换一次壁纸
switch_wallpaper_timer = hs.timer.doEvery(600, switch_wallpaper, true):start()
-- 每天自动执行一次非今日壁纸删除，以减小磁盘占用
delete_wallpaper_timer = hs.timer.doEvery(86400, delete_wallpaper, true):start()
