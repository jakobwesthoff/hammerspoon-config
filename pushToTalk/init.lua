--
-- Simple Hammerspoon script to create Push-To-Talk functionality
-- Press and hold fn key to talk
--
local log = hs.logger.new('PushToTalk','debug')
local settings = {
  pushToTalk = true
}

local modifierKeys = {}
local inputVolumes = {}
local menubarIcon = nil
local icons = {
  microphone = nil,
  mutedMicrophone = nil
}

function initInputVolumes()
  for index, device in ipairs(hs.audiodevice.allInputDevices()) do
    inputVolumes[device:uid()] = device:inputVolume()
    log.i("Initializing unmuted volume for " .. device:uid() .. ": " .. inputVolumes[device:uid()])
  end
end

function onInputDeviceChanged(uid, name, scope, element)
  if name ~= "vmvc" then
    return
  end

  if scope ~= "inpt" then
    return
  end

  local device = hs.audiodevice.findDeviceByUID(uid)
  local newVolume = device:inputVolume()

  if newVolume == 0 or newVolume == inputVolumes[uid] then
    return
  end

  inputVolumes[uid] = newVolume

  log.i("Updating unmuted volume for " .. uid .. ": " .. newVolume)
end

function installInputDeviceWatchers()
  for index, device in ipairs(hs.audiodevice.allInputDevices()) do
    device:watcherCallback(onInputDeviceChanged)
    device:watcherStart()
  end
end

function changeMicrophoneState(mute)
  if mute then
    log.i('Muting audio')
    for index, device in ipairs(hs.audiodevice.allInputDevices()) do
      device:setInputVolume(0)
    end
    menubarIcon:setIcon(icons.mutedMicrophone)
  else
    for index, device in ipairs(hs.audiodevice.allInputDevices()) do
      log.i('Unmuting audio: ' .. inputVolumes[device:uid()])
      if inputVolumes[device:uid()] == nil then
        log.i("Device with unknown inputVolume")
        device:setInputVolume(100)
      else
        device:setInputVolume(inputVolumes[device:uid()])
      end
    end
    menubarIcon:setIcon(icons.microphone)
  end
end

local keyPressed = false
local modifiersChangedTap = hs.eventtap.new(
    {hs.eventtap.event.types.flagsChanged},
    function(event)
        local modifiers = event:getFlags()
        local stateChanged = false

        local modifiersMatch = true
        for index, key in ipairs(modifierKeys) do
          if modifiers[key] ~= true then
            modifiersMatch = false
          end
        end

        if modifiersMatch then
          if keyPressed ~= true then
            stateChanged = true
          end
          keyPressed = true
        else
          if keyPressed ~= false then
            stateChanged = true
          end
          keyPressed = false
        end

        if stateChanged then
          if keyPressed then
            changeMicrophoneState(not settings.pushToTalk)
          else
            changeMicrophoneState(settings.pushToTalk)
          end
        end
    end
)

function initMenubarIcon()
  menubarIcon = hs.menubar.new()
  menubarIcon:setIcon(icons.microphone)
  menubarIcon:setMenu(function()
    return {
      {title = "Push to talk", checked = settings.pushToTalk, fn = function()
        if settings.pushToTalk == false then
          changeMicrophoneState(true)
          settings.pushToTalk = true
        end
      end},
      {title = "Push to mute", checked = not settings.pushToTalk, fn = function()
        if settings.pushToTalk == true then
          changeMicrophoneState(false)
          settings.pushToTalk = false
        end
      end},
      {title = "-"},
      {title = "Hotkey: " .. table.concat(modifierKeys, " + ")}
    }
  end)
end

function loadIcons()
  local iconPath = hs.configdir .. "/pushToTalk/icons"
  icons.microphone = hs.image.imageFromPath(iconPath .. "/microphone.pdf"):setSize({w = 16, h = 16})
  icons.mutedMicrophone = hs.image.imageFromPath(iconPath .."/microphone-slash.pdf"):setSize({w = 16, h = 16})
end

function loadSettings()
  local loadedSettings = hs.settings.get('pushToTalk.settings')
  if loadedSettings ~= nil then
    settings = loadedSettings
  end
end

function saveSettings()
  hs.settings.set('pushToTalk.settings', settings)
end

-- Public interface
local pushToTalk = {}
pushToTalk.init = function(modifiers)
  modifierKeys = modifiers or {"fn"}

  loadSettings()
  loadIcons()

  initMenubarIcon()

  initInputVolumes()
  installInputDeviceWatchers()
  changeMicrophoneState(settings.pushToTalk)

  modifiersChangedTap:start()

  local oldShutdownCallback = hs.shutdownCallback
  hs.shutdownCallback = function()
    if oldShutdownCallback ~= nil then
      oldShutdownCallback()
    end

    saveSettings()

    for index, device in ipairs(hs.audiodevice.allInputDevices()) do
      if inputVolumes[device:uid()] == nil then
        device:setInputVolume(100)
      else
        device:setInputVolume(inputVolumes[device:uid()])
      end
    end
  end
end

return pushToTalk
