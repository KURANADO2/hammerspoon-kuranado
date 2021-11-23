-- 将剪贴板中的字符以按键事件发送（解决某些网站禁止粘贴密码问题）
hs.hotkey.bind({"cmd", "alt"}, "v", "Password paste", function()
    hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)