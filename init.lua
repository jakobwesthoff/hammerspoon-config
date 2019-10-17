-- local pushToTalk = require("pushToTalk")
-- pushToTalk.init{"fn", "ctrl"}

local keystrokeToApp = require("keystrokeToApp")
keystrokeToApp.register("Slack", { "cmd" }, "k", true)


-- local screens = {
--     internal = "Color LCD",
--     external = "Thunderbolt Display"
-- }
-- 
-- local windowLayouts = require("windowLayouts")
-- windowLayouts.initialize("6x6")
-- windowLayouts.registerLayout("Zoom on External", {
--     { name = "zoom.us", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.external },
--     { name = "Google Chrome", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.internal },
--     { name = "PhpStorm", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.internal },
--     { name = "Messages", grid = hs.geometry.new(3, 0, 6, 6), screen = screens.internal },
--     { name = "Atom", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.internal },
--     { name = "Sequel Pro", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.internal },
--     { name = "Tyme 2", grid = hs.geometry.new(0, 3, 6, 6), screen = screens.internal },
--     { name = "Fantastical", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.internal },
--     { name = "Airmail", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.internal },
--     { name = "iTerm2", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.internal },
--     { name = "Slack", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.internal },
-- }, {
--     mods = "⌥⌘",
--     key = "E"
-- })
-- 
-- windowLayouts.registerLayout("Zoom on Internal", {
--     { name = "zoom.us", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.internal },
--     { name = "Google Chrome", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.external },
--     { name = "PhpStorm", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.external },
--     { name = "Messages", grid = hs.geometry.new(0, 0, 3, 6), screen = screens.external },
--     { name = "Atom", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.external },
--     { name = "Sequel Pro", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.external },
--     { name = "Tyme 2", grid = hs.geometry.new(3, 3, 6, 6), screen = screens.external },
--     { name = "Fantastical", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.external },
--     { name = "Airmail", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.external },
--     { name = "iTerm2", grid = hs.geometry.new(0, 0, 3, 6), screen = screens.external },
--     { name = "Slack", grid = hs.geometry.new(3, 0, 6, 6), screen = screens.external },
-- }, {
--     mods = "⌥⌘",
--     key = "I"
-- })
-- 
-- windowLayouts.registerLayout("Share Screen Internal", {
--     { name = "zoom.us", grid = hs.geometry.new(0, 0, 3, 3), screen = screens.external },
--     { name = "Google Chrome", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.external },
--     { name = "PhpStorm", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.internal },
--     { name = "Messages", grid = hs.geometry.new(0, 0, 3, 6), screen = screens.external },
--     { name = "Atom", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.external },
--     { name = "Sequel Pro", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.internal },
--     { name = "Tyme 2", grid = hs.geometry.new(3, 3, 6, 6), screen = screens.external },
--     { name = "Fantastical", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.external },
--     { name = "Airmail", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.external },
--     { name = "iTerm2", grid = hs.geometry.new(0, 0, 6, 6), screen = screens.internal },
--     { name = "Slack", grid = hs.geometry.new(3, 0, 6, 6), screen = screens.external },
-- }, {
--     mods = "⌥⌘",
--     key = "S"
-- })
-- 

local soundboard = require("soundboard")
soundboard.registerMetaBoardButton({ "cmd", "alt", "ctrl" }, "9")

-- Star Trek
soundboard.register("Star Trek/Autodestruct.mp3", { "cmd", "alt", "ctrl" }, "1", "Star Trek")
soundboard.register("Star Trek/Intercom.mp3", { "cmd", "alt", "ctrl" }, "2", "Star Trek")
soundboard.register("Star Trek/Incoming Message.mp3", { "cmd", "alt", "ctrl" }, "3", "Star Trek")
soundboard.register("Star Trek/Engage.mp3", { "cmd", "alt", "ctrl" }, "4", "Star Trek")
soundboard.register("Star Trek/Borg.mp3", { "cmd", "alt", "ctrl" }, "5", "Star Trek")
soundboard.register("Star Trek/Make it so.mp3", { "cmd", "alt", "ctrl" }, "6", "Star Trek")
soundboard.register("Star Trek/He is dead Jim.mp3", { "cmd", "alt", "ctrl" }, "7", "Star Trek")
soundboard.register("Star Trek/Security Clearance.mp3", { "cmd", "alt", "ctrl" }, "8", "Star Trek")
-- Ghostbusters
soundboard.register("Ghostbusters/Keymaster.mp3", { "cmd", "alt", "ctrl" }, "1", "Ghostbusters")
soundboard.register("Ghostbusters/Split up.mp3", { "cmd", "alt", "ctrl" }, "2", "Ghostbusters")
soundboard.register("Ghostbusters/Back off.mp3", { "cmd", "alt", "ctrl" }, "3", "Ghostbusters")
soundboard.register("Ghostbusters/Bad.mp3", { "cmd", "alt", "ctrl" }, "4", "Ghostbusters")
soundboard.register("Ghostbusters/Disaster.mp3", { "cmd", "alt", "ctrl" }, "5", "Ghostbusters")
soundboard.register("Ghostbusters/Return to your place of origin.mp3", { "cmd", "alt", "ctrl" }, "6", "Ghostbusters")
soundboard.register("Ghostbusters/Toys.mp3", { "cmd", "alt", "ctrl" }, "7", "Ghostbusters")
soundboard.register("Ghostbusters/Unlicensed Nuclear Accelerator.mp3", { "cmd", "alt", "ctrl" }, "8", "Ghostbusters")

-- Duke Nukem
soundboard.register("Duke Nukem/Hail to the king baby.mp3", { "cmd", "alt", "ctrl" }, "1", "Duke Nukem")
soundboard.register("Duke Nukem/Ive got balls of steel.mp3", { "cmd", "alt", "ctrl" }, "2", "Duke Nukem")
soundboard.register("Duke Nukem/Let God sort em out.mp3", { "cmd", "alt", "ctrl" }, "3", "Duke Nukem")
soundboard.register("Duke Nukem/Its my way or....mp3", { "cmd", "alt", "ctrl" }, "4", "Duke Nukem")
soundboard.register("Duke Nukem/My names Duke Nukem.mp3", { "cmd", "alt", "ctrl" }, "5", "Duke Nukem")
soundboard.register("Duke Nukem/Get back to work you slacker.mp3", { "cmd", "alt", "ctrl" }, "6", "Duke Nukem")
soundboard.register("Duke Nukem/Damn Im good..mp3", { "cmd", "alt", "ctrl" }, "7", "Duke Nukem")
soundboard.register("Duke Nukem/What theres only one of you.mp3", { "cmd", "alt", "ctrl" }, "8", "Duke Nukem")

soundboard.nextBoard()

-- soundboard.register("", { "cmd", "alt", "ctrl" }, "1")
-- soundboard.register("", { "cmd", "alt", "ctrl" }, "2")
-- soundboard.register("", { "cmd", "alt", "ctrl" }, "3")
-- soundboard.register("", { "cmd", "alt", "ctrl" }, "4")
-- soundboard.register("", { "cmd", "alt", "ctrl" }, "5")
-- soundboard.register("", { "cmd", "alt", "ctrl" }, "6")
-- soundboard.register("", { "cmd", "alt", "ctrl" }, "7")
-- soundboard.register("", { "cmd", "alt", "ctrl" }, "8")
