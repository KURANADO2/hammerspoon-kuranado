-- 功能菜单

require("modules.base")
require("modules.config")

local menubar = hs.menubar.new()

function renderMenubar(config)
    -- 用于存储所有菜单项
    local menudata = {}

    -- 字符串反序列化为 table
    config = unserialize(config)

    -- 渲染配置到 Menubar 中
    for k, v in ipairs(config) do
        -- 第一项为配置版本号
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
            end,
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
        title = "恢复默认配置",
        fn = function()
            -- 持久化配置文件
            saveConfig(defaultConfig)
            -- 重新加载 Hammerspoon 所有配置
            hs.reload()
        end,
    })
    local icon = hs.image.imageFromPath(base_path .. "images/menu.png")
    -- 调整图标大小
    local iconCopied = icon:setSize({ w = 25, h = 25 }, true)
    menubar:setIcon(iconCopied)
    -- menubar:setTitle('KURANADO')
    menubar:setTooltip("启用/禁用配置")
    menubar:setMenu(menudata)
end

renderMenubar(loadConfig())
