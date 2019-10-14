local bindings = {}

-- Public interface
local soundboard = {}
soundboard.register = function(soundfile, modifiers, character)
    local fullpath = string.format("%s/soundboard/sounds/%s", hs.configdir, soundfile)
    local sound = hs.sound.getByFile(fullpath)
    if sound == nil then
        hs.alert.show(string.format("Sound file %s could not be loaded", soundfile))
        return
    end
    local newBinding = hs.hotkey.new(modifiers, character, function()
        if sound:isPlaying() then
            sound:stop()
        else
            sound:play()
        end
    end)

    newBinding:enable()
    table.insert(bindings, newBinding)
end
return soundboard
