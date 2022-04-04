-- 输入法切换

require 'modules.shortcut'

local INPUT_CHINESE = 'com.apple.inputmethod.SCIM.ITABC'
local INPUT_ABC = 'com.apple.keylayout.ABC'
local INPUT_HIRAGANA = 'com.google.inputmethod.Japanese.base'

-- 简体拼音
function chinese()
    hs.alert.show('简体拼音')
    hs.keycodes.currentSourceID(INPUT_CHINESE)
end

-- ABC
function abc()
    hs.alert.show('ABC')
    hs.keycodes.currentSourceID(INPUT_ABC)
end

-- 平假名
function hiragana()
    hs.alert.show('Hiragana')
    hs.keycodes.currentSourceID(INPUT_HIRAGANA)
end

function toggleInput()
    local current = hs.keycodes.currentSourceID()
    -- 当前不是简体拼音，就切换为简体拼音
    if INPUT_CHINESE ~= current then
        chinese()
    else
        -- 否则切换为平假名
        hiragana()
    end
end
hs.hotkey.bind(input_method.prefix, input_method.key, toggleInput)