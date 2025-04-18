-- TODO: The current saving method is placing content in memeory which is most expensive for system,
-- it's better placing those copied content in file in following update.
-- 剪贴板历史管理器配置
local config = {
    maxEntries = 50, -- 最大保存的剪贴板条目数
    pasteOnSelect = true, -- 选择后是否自动粘贴
    hotkey = { { "cmd", "shift" }, "v" }, -- 激活快捷键
    clipboardCheckInterval = 0.5, -- 检查剪贴板的间隔（秒）
    excludedApps = { "1Password" }, -- 排除监听这些应用的复制操作
    playSound = true, -- 是否在复制时播放声音
    soundName = "Tink", -- 声音名称: Tink, Bottle, Pop, Purr, Sosumi, Submarine, Basso, Frog, Funk, Glass, Hero
}

-- 初始化剪贴板历史
local clipboardHistory = {}
local lastChange = hs.pasteboard.changeCount()
local chooser = nil
local pasteboard = hs.pasteboard

-- 检查当前应用是否在排除列表中
local function isExcludedApp()
    local currentApp = hs.application.frontmostApplication()
    if not currentApp then
        return false
    end

    local appName = currentApp:name()
    for _, excludedApp in ipairs(config.excludedApps) do
        if appName == excludedApp then
            return true
        end
    end
    return false
end

-- 播放提示音
local function playNotificationSound()
    if config.playSound then
        hs.sound.getByName(config.soundName):play()
    end
end

-- 获取剪贴板内容并保存为通用格式
local function saveClipboardContent()
    local item = {
        plainText = pasteboard.getContents(),
        styledText = pasteboard.readStyledText(),
        image = pasteboard.readImage(), -- return image or nil
        fileURLs = pasteboard.readURL(),
        availableTypes = pasteboard.typesAvailable(), -- 检查可用的UTI类型
        type = nil,
        timestamp = os.time(),
    }

    -- 确定剪贴板内容类型
    if item.availableTypes["URL"] then
        item.type = "file"
    elseif item.availableTypes["image"] and item.availableTypes["string"] == nil then
        item.type = "image"
    elseif item.availableTypes["styledText"] then
        item.type = "styledText"
    elseif item.availableTypes["string"] then -- it seems never be reached
        item.type = "plaintext"
    else
        item.type = "unknown"
    end

    return item
end

-- 获取展示文本
local function getDisplayText(item)
    if item.type == "file" then
        local path = item.fileURLs["filePath"]
        return hs.fs.displayName(path)
        -- TODO:fix the bug of only can get one file item
        -- if #item.fileURLs == 1 then
        --     local path = item.fileURLs["filePath"]
        --     return "📄 " .. hs.fs.displayName(path)
        -- else
        --     return "📄 " .. #item.fileURLs .. " 个文件"
        -- end
    elseif item.type == "image" then
        return "图片"
    elseif item.type == "styledText" then
        local plainText = item.plainText or ""
        if #plainText > 50 then
            -- TODO:change the length for better looking
            plainText = plainText:gsub("^%s*(.-)", "%1") .. "..."
            plainText = string.sub(plainText, 1, 20) .. "..."
        end
        return plainText:gsub("\n", " ↩ ")
    elseif item.type == "plainText" then
        local plainText = item.plainText or ""
        if #plainText > 50 then
            plainText = plainText:gsub("^%s*(.-)", "%1") .. "..."
            plainText = string.sub(plainText, 1, 20) .. "..."
        end
        return plainText:gsub("\n", " ↩ ")
    else
        return "❓ 未知内容"
    end
end
-- 检查两个剪贴板项目是否相似
local function areItemsSimilar(item1, item2)
    -- 如果是文件，比较路径
    if item1.type == "file" and item2.type == "file" then
        if item1.fileURLs["filePath"] == item2.fileURLs["filePath"] then
            return true
        end
    -- 如果是图片
    elseif item1.type == "image" and item2.type == "image" then
        --BUG: images cann't be compared
        return (item1.image:toASCII() == item2.image:toASCII())
        -- 对于文本内容，比较纯文本部分
        -- 检查两个剪贴板项目是否相似
    elseif item1.plainText == item2.plainText then
        return true
    end
    return false
end

-- 监控剪贴板变化
local clipboardTimer = hs.timer.new(config.clipboardCheckInterval, function()
    local now = pasteboard.changeCount()
    if now > lastChange then
        lastChange = now

        -- 如果当前应用在排除列表中，跳过
        if isExcludedApp() then
            return
        end
        -- 保存剪贴板内容
        local item = saveClipboardContent()
        item.applicationIDFrom = hs.application.frontmostApplication():bundleID()

        -- 只有当有内容时才继续
        if item.availableTypes ~= {} then
            -- 检查是否已经存在相似内容
            for i, historyItem in ipairs(clipboardHistory) do
                if areItemsSimilar(item, historyItem) then
                    table.remove(clipboardHistory, i)
                    break
                end
            end

            -- 添加到历史开头
            table.insert(clipboardHistory, 1, item)

            -- 如果超出最大限制，删除最旧的
            if #clipboardHistory > config.maxEntries then
                table.remove(clipboardHistory)
            end

            -- 播放提示音
            playNotificationSound()
        end
    end
end)
-- 还原剪贴板项目
local function restoreClipboardItem(item)
    -- 暂时禁用剪贴板监控，避免循环
    clipboardTimer:stop()

    -- 根据类型恢复剪贴板内容
    if item.type == "file" and item.fileURLs then
        pasteboard.writeObjects(item.fileURLs)
    elseif item.type == "image" and item.image then
        pasteboard.writeObjects(item.image)
    elseif item.type == "styledText" then
        pasteboard.writeObjects(item.styledText)
    elseif item.type == "plainText" and item.plainText then
        pasteboard.setContents(item.text)
    end

    -- 更新changeCount避免循环触发
    lastChange = pasteboard.changeCount()

    -- 重新启动剪贴板监控
    hs.timer.doAfter(0.5, function()
        clipboardTimer:start()
    end)
end

-- 创建选择器UI
local function createChooser()
    chooser = hs.chooser.new(function(selection)
        if not selection then
            return
        end

        -- 获取选择的剪贴板内容
        local selectedItem = clipboardHistory[selection.index]

        -- 恢复到剪贴板
        restoreClipboardItem(selectedItem)

        -- 如果配置为自动粘贴则模拟cmd+v
        if config.pasteOnSelect then
            hs.timer.doAfter(0.01, function()
                hs.eventtap.keyStroke({ "cmd" }, "v")
            end)
        end
    end)

    chooser:width(22)
    -- chooser:rows(config.max_display)
    chooser:searchSubText(true)
    chooser:placeholderText("搜索剪贴板历史...")

    return chooser
end

-- 显示选择器UI
local function showChooser()
    if not chooser then
        chooser = createChooser()
    end

    -- 准备显示项
    local choices = {}
    for i, item in ipairs(clipboardHistory) do
        if item.type == "file" then
            local path = item.fileURLs["filePath"]
            icon = hs.image.iconForFile(path)
        elseif item.type == "image" then
            icon = item.image:size({ w = 1, h = 1 })
        elseif item.type == "styledText" then
            icon = hs.image.imageFromAppBundle(item.applicationIDFrom)
        elseif item.type == "plainText" then
            icon = hs.image.imageFromAppBundle(item.applicationIDFrom)
        end

        -- 生成子文本
        local subText = os.date("%Y-%m-%d %H:%M:%S", item.timestamp)
        --TODO: complete multi files scheme.
        -- if item.type == "file" and item.fileURLs then
        --     if #item.fileURLs == 1 then
        --         subText = subText .. " | " .. item.fileURLs[1]:gsub("file://", "")
        --     else
        --         subText = subText .. " | " .. #item.fileURLs .. " 个文件"
        --     end
        -- end

        table.insert(choices, {
            text = getDisplayText(item),
            subText = subText,
            image = icon,
            index = i,
        })
    end

    chooser:choices(choices)
    chooser:show()
end

-- 绑定快捷键
hs.hotkey.bind(config.hotkey[1], config.hotkey[2], showChooser)

-- 开始监控剪贴板
clipboardTimer:start()
