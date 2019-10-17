local activeBoard = nil
local boards = {}
local openBoardAlert = nil
local showBoardTimer = nil
local inSwitchingZone = false

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

    newBinding.name = string.gsub(soundfile, "^[^/]*/?(.+)%..*$", "%1")

    if boards[boardid] == nil then
        boards[boardid] = {}
    end

    local board = boards[boardid]

    table.insert(board, newBinding)
end

soundboard.registerMetaBoardButton = function(modifiers, character)
    local newBinding = hs.hotkey.new(modifiers, character, function()
        if inSwitchingZone == true then
            soundboard.nextBoard()
        else
            soundboard.displayActiveBoard()
        end
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
    soundboard.displayActiveBoard()
end

soundboard.nextBoard = function()
    local nextBoardId, nextBoard = next(boards, activeBoard)
    if nextBoardId == nil then
        nextBoardId, nextBoard = next(boards, nil)
    end

    soundboard.switchToBoard(nextBoardId)
end

soundboard.displayActiveBoard = function()
    local template = [[
    <style type="text/css">
        * {
            font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,Ubuntu,Cantarell,"Helvetica Neue",sans-serif;
        }

        td {
            font-size: 28px;
            color: white;
            text-align: center;
            vertical-align: center;
            margin: 12px;
        }

        td.value {
            width: 30%;
        }

        td.spacer {
            width: 5%;
        }

        h1 {
            font-size: 30px;
            font-weight: normal;
            font-family: -apple-system;
            color: white;
            text-align: center;
        }

        em {
            color: goldenrod;
            font-style: normal;
        }

        table {
            margin: 0 auto;
        }
    </style>

    <h1>Soundboard: <em>{{soundboard}}</em></h1>
    <table>
        <tr>
            <td class="value">{{0}}</td>
            <td class="spacer"> | </td>
            <td class="value">{{1}}</td>
            <td class="spacer"> | </td>
            <td class="value">{{2}}</td>
      </tr>
      <tr>
          <td class="value">{{3}}</td>
          <td class="spacer"> | </td>
          <td class="value">{{4}}</td>
          <td class="spacer"> | </td>
          <td class="value">{{5}}</td>
      </tr>
      <tr>
            <td class="value">{{6}}</td>
            <td class="spacer"> | </td>
            <td class="value">{{7}}</td>
            <td class="spacer"> | </td>
            <td class="value">{{8}}</td>
      </tr>
    </table>
    ]]

    filledTemplate = string.gsub(template, "{{(.-)}}", function(v) 
        if v == "soundboard" then
            return activeBoard
        else
            local index = tonumber(v) + 1
            if boards[activeBoard][index] ~= nil then
                return boards[activeBoard][index].name
            else
                return "&nbsp;&nbsp;&nbsp;&nbsp; - &nbsp;&nbsp;&nbsp;&nbsp;"
            end
        end
    end)
    
    local formatted = hs.styledtext.getStyledTextFromData(filledTemplate, "html")

    if showBoardTimer ~= nil then
        showBoardTimer:stop()
        showBoardTimer = nil
    end

    showBoardTimer = hs.timer.doAfter(4, function() 
        inSwitchingZone = false
        showBoardTimer = nil
    end)
    inSwitchingZone = true

    if openBoardAlert ~= nil then
        hs.alert.closeSpecific(openBoardAlert, 0)
    end
    openBoardAlert = hs.alert.show(formatted, 4)
end

return soundboard
