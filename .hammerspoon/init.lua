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
  function k:entered() hs.alert'Entered mode' end
  function k:exited()  hs.alert'Exited mode'  end
  for key, app in pairs(appShortcuts) do
    k:bind('',key,nil,function() launchOrActivateApp(app,k) end)
  end
end


-- Grid 
function gridBindings()
  local grid = require "hs.grid"
  hs.window.animationDuration=0.2
  local hotkey = require "hs.hotkey"

  grid.MARGINX = 20
  grid.MARGINY = 20
  grid.GRIDHEIGHT = 4
  grid.GRIDWIDTH = 6

  local mod_resize = {"ctrl", "cmd"}
  local mod_move = {"ctrl", "alt"}
  
  hotkey.bind(mod_resize, 'k', grid.resizeWindowShorter)
end
--



k = hs.hotkey.modal.new(hyper, 'd')
function k:entered() hs.alert'Entered mode' end
function k:exited()  hs.alert'Exited mode'  end
k:bind('', 'escape', function() k:exit() end)

defineAppKeybindings()
gridBindings()
hs.alert.show(sys_name .. " loaded!", 3)

