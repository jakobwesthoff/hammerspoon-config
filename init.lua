-- local pushToTalk = require("pushToTalk")
-- pushToTalk.init{"fn", "ctrl"}

local keystrokeToApp = require("keystrokeToApp")
keystrokeToApp.register("Slack", {"cmd"}, "k", true)


local screens = {
  internal = "Color LCD",
  external = "Thunderbolt Display"
}

local windowLayouts = require("windowLayouts")
windowLayouts.initialize("6x6")
windowLayouts.registerLayout("Zoom on External", {
  {app="zoom.us", grid=hs.geometry.new(0,0,6,6), screen=screens.external},
  {app="Google Chrome", grid=hs.geometry.new(0,0,6,6), screen=screens.internal},
  {app="PhpStorm", grid=hs.geometry.new(0,0,6,6), screen=screens.internal},
  {app="Messages", grid=hs.geometry.new(3,0,6,6), screen=screens.internal},
  {app="Atom", grid=hs.geometry.new(0,0,6,6), screen=screens.internal},
  {app="Sequel Pro", grid=hs.geometry.new(0,0,6,6), screen=screens.internal},
  {app="Tyme 2", grid=hs.geometry.new(0,3,6,6), screen=screens.internal},
  {app="Fantastical", grid=hs.geometry.new(0,0,6,6), screen=screens.internal},
  {app="Airmail", grid=hs.geometry.new(0,0,6,6), screen=screens.internal},
  {app="iTerm2", grid=hs.geometry.new(0,0,6,6), screen=screens.internal},
  {app="Slack", grid=hs.geometry.new(0,0,6,6), screen=screens.internal},
})

windowLayouts.registerLayout("Zoom on Internal", {
  {app="zoom.us", grid=hs.geometry.new(0,0,6,6), screen=screens.internal},
  {app="Google Chrome", grid=hs.geometry.new(0,0,6,6), screen=screens.external},
  {app="PhpStorm", grid=hs.geometry.new(0,0,6,6), screen=screens.external},
  {app="Messages", grid=hs.geometry.new(0,0,3,6), screen=screens.external},
  {app="Atom", grid=hs.geometry.new(0,0,6,6), screen=screens.external},
  {app="Sequel Pro", grid=hs.geometry.new(0,0,6,6), screen=screens.external},
  {app="Tyme 2", grid=hs.geometry.new(3,3,6,6), screen=screens.external},
  {app="Fantastical", grid=hs.geometry.new(0,0,6,6), screen=screens.external},
  {app="Airmail", grid=hs.geometry.new(0,0,6,6), screen=screens.external},
  {app="iTerm2", grid=hs.geometry.new(0,0,3,6), screen=screens.external},
  {app="Slack", grid=hs.geometry.new(3,0,6,6), screen=screens.external},
})
