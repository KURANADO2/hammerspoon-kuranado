function charsize(ch)
    if not ch then
        return 0
    elseif ch >= 252 then
        return 6
    elseif ch >= 248 and ch < 252 then
        return 5
    elseif ch >= 240 and ch < 248 then
        return 4
    elseif ch >= 224 and ch < 240 then
        return 3
    elseif ch >= 192 and ch < 224 then
        return 2
    elseif ch < 192 then
        return 1
    end
end

function utf8len(str)
    local len = 0
    local aNum = 0 --字母个数
    local hNum = 0 --汉字个数
    local currentIndex = 1
    while currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        local cs = charsize(char)
        currentIndex = currentIndex + cs
        len = len + 1
        if cs == 1 then
            aNum = aNum + 1
        elseif cs >= 2 then
            hNum = hNum + 1
        end
    end
    return len, aNum, hNum
end

function utf8sub(str, startChar, numChars)
    local startIndex = 1
    while startChar > 1 do
        local char = string.byte(str, startIndex)
        startIndex = startIndex + charsize(char)
        startChar = startChar - 1
    end

    local currentIndex = startIndex

    while numChars > 0 and currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + charsize(char)
        numChars = numChars - 1
    end
    return str:sub(startIndex, currentIndex - 1)
end

-- table to string 序列化
function serialize(obj)
    local lua = ""
    local t = type(obj)
    if t == "number" then
        lua = lua .. obj
    elseif t == "boolean" then
        lua = lua .. tostring(obj)
    elseif t == "string" then
        lua = lua .. string.format("%q", obj)
    elseif t == "table" then
        lua = lua .. "{\n"
        for k, v in pairs(obj) do
            lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
        end
        local metatable = getmetatable(obj)
        if metatable ~= nil and type(metatable.__index) == "table" then
            for k, v in pairs(metatable.__index) do
                lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
            end
        end
        lua = lua .. "}"
    elseif t == "nil" then
        return nil
    else
        error("can not serialize a " .. t .. " type.")
    end
    return lua
end

-- string to table 反序列化
function unserialize(lua)
    local t = type(lua)
    if t == "nil" or lua == "" then
        return nil
    elseif t == "number" or t == "string" or t == "boolean" then
        lua = tostring(lua)
    else
        error("can not unserialize a " .. t .. " type.")
    end
    lua = "return " .. lua
    local func = load(lua)
    if func == nil then
        return nil
    end
    return func()
end

function split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if delimiter == "" then
        return false
    end
    local pos, arr = 0, {}
    -- for each divider found
    for st, sp in
        function()
            return string.find(input, delimiter, pos, true)
        end
    do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

function trim(s)
    if s == nil then
        return ""
    end
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

function pushleft(list, value)
    local first = list.first - 1
    list.first = first
    list[first] = value
end

function pushright(list, value)
    local last = list.last + 1
    list.last = last
    list[last] = value
end

function popleft(list)
    local first = list.first
    if first > list.last then
        error("list is empty")
    end
    local value = list[first]
    list[first] = nil -- to allow garbage collection
    list.first = first + 1
    return value
end

function popright(list)
    local last = list.last
    if list.first > last then
        error("list is empty")
    end
    local value = list[last]
    list[last] = nil -- to allow garbage collection
    list.last = last - 1
    return value
end

function day_step(old_day, step)
    local y, m, d
    if "0" ~= string.sub(old_day, 6, 6) then
        m = string.sub(old_day, 6, 7)
    else
        m = string.sub(old_day, 7, 7)
    end

    if "0" ~= string.sub(old_day, 9, 9) then
        d = string.sub(old_day, 9, 10)
    else
        d = string.sub(old_day, 10, 10)
    end

    y = string.sub(old_day, 0, 4)

    local old_time = os.time({ year = y, month = m, day = d })
    local new_time = old_time + 86400 * step

    local new_day = os.date("*t", new_time)
    local res = ""

    if tonumber(new_day.day) < 10 and tonumber(new_day.month) < 10 then
        res = new_day.year .. "-" .. "0" .. new_day.month .. "-" .. "0" .. new_day.day
    elseif tonumber(new_day.month) < 10 then
        res = new_day.year .. "-" .. "0" .. new_day.month .. "-" .. new_day.day
    elseif tonumber(new_day.day) < 10 then
        res = new_day.year .. "-" .. new_day.month .. "-" .. "0" .. new_day.day
    else
        res = new_day.year .. "-" .. new_day.month .. "-" .. new_day.day
    end
    return res
end
