--
-- Simple Hammerspoon script to create Push-To-Talk functionality
-- Press and hold fn key to talk
--
local log = hs.logger.new('PushToTalk','debug')
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

function muteMicrophone()
  log.i('Muting audio')
  for index, device in ipairs(hs.audiodevice.allInputDevices()) do
    device:setInputVolume(0)
  end
  menubarIcon:setIcon(icons.mutedMicrophone)
end

function unmuteMicrophone()
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

local keyPressed = false
local modifiersChangedTap = hs.eventtap.new(
    {hs.eventtap.event.types.flagsChanged},
    function(event)
        local modifiers = event:getFlags()
        local stateChanged = false

        if modifiers["fn"] then
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
            unmuteMicrophone()
          else
            muteMicrophone()
          end
        end
    end
)

function initMenubarIcon()
  menubarIcon = hs.menubar.new()
  menubarIcon:setIcon(icons.microphone)
end

function loadIcons()
  local iconPath = hs.configdir .. "/pushToTalk/icons"
  icons.microphone = hs.image.imageFromPath(iconPath .. "/microphone.pdf"):setSize({w = 16, h = 16})
  icons.mutedMicrophone = hs.image.imageFromPath(iconPath .."/microphone-slash.pdf"):setSize({w = 16, h = 16})
end

-- Public interface
local pushToTalk = {}
pushToTalk.init = function()
  loadIcons()
  initMenubarIcon()

  initInputVolumes()
  installInputDeviceWatchers()
  muteMicrophone()

  modifiersChangedTap:start()

  local oldShutdownCallback = hs.shutdownCallback
  hs.shutdownCallback = function()
    if oldShutdownCallback ~= nil then
      oldShutdownCallback()
    end

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
