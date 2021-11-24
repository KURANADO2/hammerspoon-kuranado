-- 将剪贴板中的字符以按键事件发送（解决某些网站禁止粘贴密码问题）
hs.hotkey.bind({"ctrl", "cmd"}, "v", "Password Paste", function()
    hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)