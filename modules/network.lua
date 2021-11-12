local menubar = hs.menubar.new()
local menuData = {}

-- ipv4Interface ipv6 Interface
local interface = hs.network.primaryInterfaces()

-- 该对象用于存储全局变量，避免每次获取速度都创建新的局部变量
local obj = {}

function init()
    if interface then
        local interface_detail = hs.network.interfaceDetails(interface)
        if interface_detail.IPv4 then
            local ipv4 = interface_detail.IPv4.Addresses[1]
            table.insert(menuData, {
                title = "IPv4:" .. ipv4,
                tooltip = "Copy Ipv4 to clipboard",
                fn = function()
                    hs.pasteboard.setContents(ipv4)
                end
            })
        end
        local mac = hs.execute('ifconfig ' .. interface .. ' | grep ether | awk \'{print $2}\'')
        table.insert(menuData, {
            title = 'MAC:' .. mac,
            tooltip = 'Copy MAC to clipboard',
            fn = function()
                hs.pasteboard.setContents(mac)
            end
        })

        obj.last_down = hs.execute('netstat -ibn | grep -e ' .. interface .. ' -m 1 | awk \'{print $7}\'')
        obj.last_up = hs.execute('netstat -ibn | grep -e ' .. interface .. ' -m 1 | awk \'{print $10}\'')
    end

    menubar:setMenu(menuData)
end

function scan()
    if interface then
        obj.current_down = hs.execute('netstat -ibn | grep -e ' .. interface .. ' -m 1 | awk \'{print $7}\'')
        obj.current_up = hs.execute('netstat -ibn | grep -e ' .. interface .. ' -m 1 | awk \'{print $10}\'')

        obj.down_bytes = obj.current_down - obj.last_down
        obj.up_bytes = obj.current_up - obj.last_up

        obj.down_speed = format_speed(obj.down_bytes)
        obj.up_speed = format_speed(obj.up_bytes)

        obj.display_text = hs.styledtext.new('▲ ' .. obj.up_speed .. '\n▼ ' .. obj.down_speed, {font={size=9}, color={hex='#FFFFFF'}, paragraphStyle={alignment="left", maximumLineHeight=18}})

        obj.last_down = obj.current_down
        obj.last_up = obj.current_up

        local canvas = hs.canvas.new{x = 0, y = 0, h = 24, w = 70}
        canvas[1] = {type = 'text', text = obj.display_text}
        menubar:setIcon(canvas:imageFromCanvas())
        canvas:delete()
        canvas = nil
    end
end

function format_speed(bytes)
    -- 单位 Byte/s
    if bytes < 1024 then
        return string.format('%6.0f', bytes) .. ' B/s'
    else
        -- 单位 KB/s
        if bytes < 1048576 then
            -- 因为是每两秒刷新一次，所以要除以 （1024 * 2）
            return string.format('%6.1f', bytes / 2048) .. ' KB/s'
            -- 单位 MB/s
        else
            -- 除以 （1024 * 1024 * 2）
            return string.format('%6.1f', bytes / 2097152) .. ' MB/s'
        end
    end
end

init()
scan()
if obj.timer then
    obj.timer:stop()
    obj.timer = nil
end
-- 第三个参数表示当发生异常情况时，定时器是否继续执行下去
obj.timer = hs.timer.doEvery(2, scan, true):start()