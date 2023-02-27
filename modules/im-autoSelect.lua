
  local function DefaultIM()
    --hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
    -- hs.keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Hans")
    hs.keycodes.currentSourceID("com.baidu.inputmethod.BaiduIM.pinyin")
  end
  local function Chinese()
    --hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
    -- hs.keycodes.currentSourceID("com.apple.inputmethod.SCIM.ITABC")
    hs.keycodes.currentSourceID("com.baidu.inputmethod.BaiduIM.pinyin")
  end
  
  local function English()
    -- hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
    hs.keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Hans")
  end
  
  -- app to expected ime config
  local app2Ime = {
    -- {'/Applications/iTerm.app', 'English'},
    -- {'/Applications/Xcode.app', 'English'},
    -- {'/Applications/Google Chrome.app', 'Chinese'},
    -- {'/System/Library/CoreServices/Finder.app', 'English'},
    -- {'/Applications/DingTalk.app', 'Chinese'},
    -- {'/Applications/Kindle.app', 'English'},
    -- {'/Applications/NeteaseMusic.app', 'Chinese'},
    -- {'/Applications/微信.app', 'Chinese'},
    -- {'/Applications/System Preferences.app', 'English'},
    -- {'/Applications/Dash.app', 'English'},
    -- {'/Applications/MindNode.app', 'Chinese'},
    -- {'/Applications/Preview.app', 'Chinese'},
    -- {'/Applications/wechatwebdevtools.app', 'English'},
    -- {'/Applications/Sketch.app', 'English'},
    -- {'/Applications/iShot.app', 'Chinese'},
    {'/var/folders/04/1gyprfy51tq28pynnndlcn000000gn/T/AppTranslocation/8B88DD98-13BF-460E-8EA2-5A10C8A5CC9C/d/Visual Studio Code.app', 'English'},
  }
  
  function updateFocusAppInputMethod()
    local focusAppPath = hs.window.frontmostWindow():application():path()
    for index, app in pairs(app2Ime) do
        local appPath = app[1]
        local expectedIme = app[2]
        DefaultIM()
        if focusAppPath == appPath then
            if expectedIme == 'English' then
                English()
            else
                Chinese()
            end
            break
        end
    end
  end
  
  -- helper hotkey to figure out the app path and name of current focused window
  hs.hotkey.bind({'ctrl', 'cmd'}, ".", function()
    hs.alert.show("App path:        "
    ..hs.window.focusedWindow():application():path()
    .."\n"
    .."App name:      "
    ..hs.window.focusedWindow():application():name()
    .."\n"
    .."IM source id:  "
    ..hs.keycodes.currentSourceID())
  end)
  
  -- Handle cursor focus and application's screen manage.
  function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        updateFocusAppInputMethod()
    end
  end

  appWatcher = hs.application.watcher.new(applicationWatcher)
  appWatcher:start()