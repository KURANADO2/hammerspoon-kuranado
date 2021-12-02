-- 功能菜单

require 'modules.base'

-- 默认加载的功能模块
defaultConfig = {{
    -- TODO-JING 针对配置版本号做判断
    configVersion = '1'
}, {
    module = 'modules.window',
    name = '窗口管理',
    enable = true
}, {
    module = 'modules.application',
    name = '应用切换',
    enable = true
}, {
    module = 'modules.password',
    name = '密码粘贴',
    enable = true
}, {
    module = 'modules.network',
    name = '实时网速',
    enable = true
}, {
    module = 'modules.hotkey',
    name = '快捷键列表查看',
    enable = true
}, {
    module = 'modules.remind',
    name = '提醒下班',
    enable = false
}}

-- 本地持久化配置
-- config = 
file = io.open('~/.hammerspoon/.config', 'w+')

local menubar = hs.menubar.new()

-- 加载本地持久化配置
function loadConfig()
    local file = io.open(os.getenv("HOME") .. '/.hammerspoon/.config', 'r')
    local config = file:read('*a')
    -- 配置文件中不存在配置
    if config == '' then
        -- 读取默认配置
        config = serialize(defaultConfig)
    end
    file:close()
    return config
end

function saveConfig(config)
    -- 清空文件内容，然后写入新的文件内容
    file = io.open(os.getenv("HOME") .. '/.hammerspoon/.config', 'w+')
    file:write(serialize(config))
    file:close()
end

function renderMenubar(config)

    -- 用于存储所有菜单项
    local menudata = {}

    -- 字符串反序列化为 table
    config = unserialize(config)

    -- 渲染配置到 Menubar 中
    for k, v in ipairs(config) do
        -- 第一项为应用版本号
        if k == 1 then
            goto continue
        end
        -- 配置项
        local item = {
            title = v.name,
            -- 是否启用
            checked = v.enable,
            -- 点击菜单项触发的函数
            fn = function()
                -- 启用 -> 禁用 或 禁用 -> 启用
                v.enable = not v.enable
                -- 持久化配置文件
                saveConfig(config)
                -- 重新加载 Hammerspoon 所有配置
                hs.reload()
            end
        }
        table.insert(menudata, item)
        -- 分割线
        -- table.insert(menudata, {title = '-'})
        -- 加载启用的模块
        if v.enable then
            require(v.module)
        end
        ::continue::
    end

    -- 默认配置
    table.insert(menudata, {
        title = '恢复默认配置',
        fn = function()
            -- 持久化配置文件
            saveConfig(defaultConfig)
            -- 重新加载 Hammerspoon 所有配置
            hs.reload()
        end
    })
    local icon = hs.image.imageFromPath('~/.hammerspoon/images/menu.png')
    -- 调整图标大小
    local iconCopied = icon:setSize({w = 25, h = 25}, true)
    menubar:setIcon(iconCopied)
    -- menubar:setTitle('KURANADO')
    menubar:setTooltip('启用/禁用配置')
    menubar:setMenu(menudata)
end

renderMenubar(loadConfig())