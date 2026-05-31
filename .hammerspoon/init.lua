hs.allowAppleScript(true)

local appShortcuts = {
    { mods = { "cmd" }, key = "b", app = "Google Chrome" },
    { mods = { "cmd" }, key = "return", app = "Alacritty" },
    { mods = { "cmd" }, key = "g", app = "ChatGPT" },
    { mods = { "cmd" }, key = "d", app = "Codex" },
    { mods = { "cmd" }, key = "m", app = "Music" },
    { mods = { "cmd" }, key = "x", app = "WhatsApp" },
    { mods = { "cmd" }, key = "z", app = "Signal" },
    { mods = { "cmd" }, key = "delete", app = "Google Chrome" },
}

local previousApp = nil

local function toggleApp(appName)
    local current = hs.application.frontmostApplication()
    if current and current:name() == appName then
        if previousApp then
            previousApp:activate()
        end
    else
        previousApp = current
        hs.application.launchOrFocus(appName)
    end
end

for _, binding in ipairs(appShortcuts) do
    hs.hotkey.bind(binding.mods, binding.key, function()
        toggleApp(binding.app)
    end)
end

local configWatcher = hs.pathwatcher.new(hs.configdir .. "/init.lua", function()
    hs.reload()
end)
configWatcher:start()

hs.alert.show("Hammerspoon config loaded")
