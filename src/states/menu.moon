Gamestate = require "lib.gamestate"
menu = {}
w, h = 800, 600

ignored_states = {
  template: true
  menu: true
}

menu.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

  list = love.filesystem.getDirectoryItems "states"
  menu.states = {}
  menu.text = ""
  for item in *list
    -- i, j = item\find ".+%.lua$" -- if it's a Lua file
    -- if i
    if item\find ".+%.lua$" -- if it's a Lua file
      item = item\sub 1, -5
      unless ignored_states[item]
        menu.states[item\sub 1, 1] = item
        menu.text ..= "Press \"#{item\sub 1, 1}\" for #{item}\n"

love.draw = =>
  fontSize = love.graphics.getFont!\getHeight!
  -- for index, item in ipairs menu.states
  --   love.graphics.print item, 1, 1 + (fontSize + 1) * (index - 1)
  love.graphics.print menu.text, 1, 1

menu.keypressed = (key) =>
  switch key
    when "escape"
      love.event.quit!
    when "g"
      Gamestate.push require "states.galaxy"
    when "t"
      Gamestate.push require "states.tinyclone"
    else
      if menu.states[key]
        Gamestate.push require "states.#{menu.states[key]}"

return menu
