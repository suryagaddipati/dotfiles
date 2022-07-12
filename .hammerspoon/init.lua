-- Set up hotkey combinations
local hyper = {"cmd", "alt", "ctrl","shift"}
local log = hs.logger.new('hammerspoon','debug')
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
  ['M'] = 'Spotify',
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

definePomodoroKeyBindings()
-- Grid 


function winFunc(key,k,func)
  k:bind('',key,nil,function() k:exit() ; func()   end)
end

function gridBindings()
  hs.window.animationDuration=0.2
  local grid = require "hs.grid"

  grid.MARGINX = 20
  grid.MARGINY = 20
  grid.GRIDHEIGHT = 4
  grid.GRIDWIDTH = 6

  local mod_resize = {"ctrl", "cmd"}
  local mod_move = {"ctrl", "alt"}

  k = hs.hotkey.modal.new(hyper, 'w')
  function k:entered() hs.alert'window' end
  winFunc('t',k, grid.resizeWindowTaller)
  winFunc('s',k, grid.resizeWindowShorter)
  winFunc('w',k, grid.resizeWindowWider)
  winFunc('h',k, grid.resizeWindowThinner)


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

hs.alert.show(sys_name .. " loaded!", 3)

