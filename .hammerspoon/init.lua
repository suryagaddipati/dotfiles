-- Set up hotkey combinations
local hyper = {"cmd", "alt", "ctrl","shift"}
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

function launchOrActivateApp(appName)
  hs.application.launchOrFocus(appName)
end

appShortcuts = {
  ['A'] = 'Alacritty',
  ['T'] = 'Alacritty',
  ['F'] = 'Firefox',
  ['S'] = 'Slack',
  ['J'] = 'IntelliJ IDEA',
  ['M'] = 'Spotify',
}

-- Bindings
function defineKeybindings()
  for key, app in pairs(appShortcuts) do
    hs.hotkey.bind(hyper, key, function() launchOrActivateApp(app) end)
  end
  hs.hotkey.bind(hyper, "R", reloadAndAlert)
end

defineKeybindings()
hs.alert.show(sys_name .. " loaded!", 3)
