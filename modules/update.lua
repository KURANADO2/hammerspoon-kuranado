-- 自动检查更新
require 'modules.base'
require 'modules.config'

function checkUpdate()
    hs.execute('cd ' .. base_path)
    local result = hs.execute('git pull origin main')
    print('Pull Result:', result)
    -- 已是最新
    -- if string.find(result, '.*Already up to date..*') ~= nil then
    --     return
    -- end
    -- 假设没有冲突
    -- 用户配置文件
    local customConfig = unserialize(loadConfig())
    -- 用户配置文件版本号 < 默认配置文件版本号
    if customConfig[1].configVersion < defaultConfig[1].configVersion then
        local newConfig = {}
        -- 开始合并配置文件
        for k, v in ipairs(defaultConfig) do
            local item = {}
            if k == 1 then
                item.configVersion = defaultConfig[1].configVersion
            end
            local exists = false
            for i, j in ipairs(customConfig) do
                -- 同一配置项
                if v.name == j.name then
                    item.name = v.name
                    item.module = v.module
                    -- 使用用户原有配置
                    item.enable = j.enable
                    exists = true
                end
            end
            -- 找不到配置项，说明为本次更新新增的配置项
            if not exists then
                item.name = v.name
                item.module = v.module
                -- 使用用户原有配置
                item.enable = v.enable
            end
            table.insert(newConfig, item)
        end
        -- 保存合并后的配置
        saveConfig(newConfig)
        -- 重新加载 Hammerspoon 所有配置
        hs.reload()
    end
    -- 如果存在冲突，如何提示用户？
    -- ...
end

-- 每次重载配置后，检查默认配置和用户配置版本号是否相同，如果不同，则主动检查一遍更新，否则无需检查更新
function checkUpdateForReload()
    local customConfig = unserialize(loadConfig())
    if customConfig[1].configVersion == defaultConfig[1].configVersion then
        return
    else
        checkUpdate()
    end
end

checkUpdateForReload()

-- 每天 12 点检查一遍更新
start = hs.timer.doAt('12:00', hs.timer.days(1), checkUpdate):start()
