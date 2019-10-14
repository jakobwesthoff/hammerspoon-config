local activeBoard = nil
local boards = {}
local openBoardAlert = nil

-- Public interface
local soundboard = {}
soundboard.register = function(soundfile, modifiers, character, boardid)
    if boardid == nil then
        boardid = "default"
    end

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

    if boards[boardid] == nil then
        boards[boardid] = {}
    end

    local board = boards[boardid]

    table.insert(board, newBinding)
end

soundboard.registerNextBoard = function(modifiers, character)
    local newBinding = hs.hotkey.new(modifiers, character, function()
        soundboard.nextBoard()
    end)
    newBinding:enable()
end

soundboard.switchToBoard = function(boardid)
    if boards[boardid] == nil then
        hs.alert.show(string.format("Soundboard %s is not defined", boardid))
        return
    end

    if activeBoard ~= nil then
        local oldBoard = boards[activeBoard]
        for i, binding in ipairs(oldBoard) do
            binding:disable()
        end
    end

    local newBoard = boards[boardid]
    for i, binding in ipairs(newBoard) do
        binding:enable()
    end

    activeBoard = boardid
    if openBoardAlert ~= nil then
        hs.alert.closeSpecific(openBoardAlert, 0)
    end
    openBoardAlert = hs.alert.show(string.format(" Soundboard: %s", boardid))
end

soundboard.nextBoard = function()
    local nextBoardId, nextBoard = next(boards, activeBoard)
    if nextBoardId == nil then
        nextBoardId, nextBoard = next(boards, nil)
    end

    soundboard.switchToBoard(nextBoardId)
end

return soundboard
