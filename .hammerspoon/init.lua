-- Set up hotkey combinations
local hyper = {"cmd", "alt", "ctrl","shift"}
local log = hs.logger.new('surya config','debug')
log.i("init")

sys_name  = "Hammerspoon"
local myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", hs.reload):start()

hs.window.animationDuration = 0.15

expose = hs.expose.new(hs.window.filter.new():setDefaultFilter({allowTitles=1}),{
  showThumbnails                  = false
})

hs.grid.setMargins({0, 0})
hs.grid.setGrid('6x4', nil)

function reloadAndAlert()
  hs.alert.show("Reloading " .. sys_name)
  hs.reload()
  hs.alert.show(sys_name .. " reloaded!")
end

function launchOrActivateApp(appName,k)
  hs.application.launchOrFocus(appName)
  k:exit() 
end

appShortcuts = {
  ['A'] = 'Alacritty',
  ['T'] = 'Alacritty',
  ['F'] = 'Firefox',
  ['S'] = 'Slack',
  ['I'] = 'IntelliJ IDEA',
  ['C'] = 'Calendar',
  ['M'] = 'Google Meet',
  ['O'] = 'Obsidian',
  ['G'] = 'Mail',
  ['P'] = 'Spotify',
  ['V'] = 'Visual Studio Code',
}

-- Bindings
function defineAppKeybindings()
  k = hs.hotkey.modal.new(hyper, 'a')
  function k:entered() hs.alert'launch' end
  for key, app in pairs(appShortcuts) do
    k:bind('',key,nil,function() launchOrActivateApp(app,k) end)
  end
end

defineAppKeybindings()

-- Pomodoro
function startPomo(k)
  k:exit()
  log.i(spoon.Cherry)
  spoon.Cherry:start()
end

function definePomodoroKeyBindings()
  hs.loadSpoon("Cherry")
  k = hs.hotkey.modal.new(hyper, 'p')
  function k:entered() hs.alert'pomodoro' end
  function k:exited() hs.alert'pomo exilaulaunchncht' end
  k:bind('','s',nil,function()  startPomo(k) end)
end

--definePomodoroKeyBindings()
-- Grid 


function winFunc(key,k,func)
  k:bind('',key,nil,function() k:exit() ; func()   end)
end



function centerTheWindow(cwin)
		local cscreen = cwin:screen()
		local cres = cscreen:frame()
		local wf = cwin:frame()
		local desiredWidth = cres.w/1.4
		local desiredHeight = cres.h/1.4
		local emptyWidth = (cres.w - desiredWidth)/2
		cwin:setFrame({x=cres.x+emptyWidth, y=cres.y, w=desiredWidth, h=desiredHeight})
end

function centerWindow()
	local cwin = hs.window.focusedWindow()
	if cwin then
   centerTheWindow(cwin)
	else
		log.i("no focused window")
	end
end


function gridBindings()

  hs.loadSpoon("WinWin")

  j = hs.hotkey.modal.new(hyper, 'w')

  function j:entered() hs.alert'window' end
  --function j:exited() hs.alert'exit window' end

  winFunc('h',j, function() spoon.WinWin:moveAndResize('halfleft') end )
  winFunc('k',j, function() spoon.WinWin:moveAndResize('halfright') end )
  winFunc('u',j, function() spoon.WinWin:moveAndResize('halfup') end )
  winFunc('n',j, function() spoon.WinWin:moveAndResize('halfdown') end )
  winFunc('j',j, function() spoon.WinWin:moveAndResize('center') end )
  winFunc('f',j, function() spoon.WinWin:moveAndResize('maximize') end )
  winFunc('c',j, centerWindow)

  winFunc('right',j, function() spoon.WinWin:moveToScreen('next') end )
  winFunc('up',j, function() spoon.WinWin:stepResize('up') end )
  winFunc('down',j, function() spoon.WinWin:stepResize('down') end )

  -- Move Window
  -- hotkey.bind(mod_move, 'j', grid.pushWindowDown)
  -- hotkey.bind(mod_move, 'k', grid.pushWindowUp)
  -- hotkey.bind(mod_move, 'h', grid.pushWindowLeft)
  -- hotkey.bind(mod_move, 'l', grid.pushWindowRight)
  --
  -- -- Resize Window
  -- hotkey.bind(mod_resize, 'k', grid.resizeWindowShorter)
  -- hotkey.bind(mod_resize, 'j', grid.resizeWindowTaller)
  -- hotkey.bind(mod_resize, 'l', grid.resizeWindowWider)
  -- hotkey.bind(mod_resize, 'h', grid.resizeWindowThinne
end
--
--
gridBindings()


function applicationWatcher(appName, eventType, appObject)
		local dell = hs.screen('Dell')
		local laptop= hs.screen('Built%-in')
    if (eventType == hs.application.watcher.activated or  eventType == hs.application.watcher.unhidden) then
        if (appName == "Slack" or appName=="Google Meet") then
            local slackWindow  = hs.window.find(appName)
						slackWindow:moveToScreen(dell)
            centerTheWindow(slackWindow)
        end
    end

    if (eventType == hs.application.watcher.deactivated or eventType == hs.application.watcher.hidden) then
        if (appName == "Slack" or appName=="Google Meet") then
            local slackWindow  = hs.window.find(appName)
						slackWindow:moveToScreen(laptop)
            slackWindow:maximize()
            slackWindow:raise()
        end
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()


hs.alert.show(sys_name .. " loaded!", 3)

