-- 密码粘贴

require 'modules.shortcut'

-- 将剪贴板中的字符以按键事件发送（解决某些网站禁止粘贴密码问题）
hs.hotkey.bind(password_paste.prefix, password_paste.key, password_paste.message, function()
    hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)