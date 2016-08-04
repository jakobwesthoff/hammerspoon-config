-- local pushToTalk = require("pushToTalk")
-- pushToTalk.init{"fn", "ctrl"}

local keystrokeToApp = require("keystrokeToApp")
keystrokeToApp.register("Slack", {"cmd"}, "k", true)
