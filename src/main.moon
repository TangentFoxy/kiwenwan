Gamestate = require "lib.gamestate"
menu = require "states.menu"

priority = "galaxy" -- set to bypass main menu

love.load = ->
  Gamestate.registerEvents!
  if priority
    Gamestate.switch require "states.#{priority}"
  else
    Gamestate.switch menu
