-- 输入法切换

require 'modules.shortcut'

local INPUT_CHINESE = 'com.apple.inputmethod.SCIM.ITABC'
local INPUT_ABC = 'com.apple.keylayout.ABC'
local INPUT_HIRAGANA = 'com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese'

-- 简体拼音
local function chinese()
    hs.keycodes.currentSourceID(INPUT_CHINESE)
end

-- ABC
local function abc()
    hs.keycodes.currentSourceID(INPUT_ABC)
end

-- 平假名
local function hiragana()
    hs.keycodes.currentSourceID(INPUT_HIRAGANA)
end

if (input_methods ~= nil) then
    hs.hotkey.bind(input_methods.abc.prefix, input_methods.abc.key, input_methods.abc.message, abc)
    hs.hotkey.bind(input_methods.chinese.prefix, input_methods.chinese.key, input_methods.chinese.message, chinese)
    hs.hotkey.bind(input_methods.japanese.prefix, input_methods.japanese.key, input_methods.japanese.message, hiragana)
end
