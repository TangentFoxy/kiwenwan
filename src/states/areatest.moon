Gamestate = require "lib.gamestate"
lume = require "lib.lume"

areatest = {}
w, h = 960, 540

export_data = false

systems = {}
system_colors = {}
areatest.init = =>
  seed = os.time!
  print "Seed: #{seed}"
  -- an exceedingly rare combination arises from the seed 1710196022 (no 8s, a 9, a 10)
  love.math.setRandomSeed seed
  radius = love.math.randomNormal 25, 4500
  -- radius = radius * 1.15 -- I will adjust the starting point larger later, because more is being removed
  -- 0.0048 seems to work okay for a "near-Earth" vibe?
  -- 2.03e-5 is based on taking a slice of the milky way, and generates ~63 systems / kly (at 50kly total radius)
  --   160k stars for the "complate" galaxy, which would equate to 1.6e8 stars 'at proper volume', which is still far under the true number
  -- 2.03e-3: okay, going to try aiming for 1.592e8 stars (it works out precisely, and takes several seconds to render a single frame)
  --   8 seconds from compile to first frame rendered, so 580 times too much at the best case
  -- I'm dividing the density by 3, and the size of the galaxy by 10 - in effect, 3000 times smaller now
  --   this requires a maximum of only ~2k systems to be rendered at once; but I have issues rendering more than 500 (with paths)
  --   seems around 250k simple calculations per frame is a maximum (that was with doubled looping)
  --   rendering a system requires 2-4 calculations ? I had no issue rendering 5000 at once, estimating 5 calcs/system, running 50k works, so does 100k
  -- (also since I'm only counting systems, and systems have on average like 1.5 stars each, the actual density is higher than what my calculations here show)
  count = math.floor math.pi * radius^2 * 2.03e-3 / 1.95       -- area * density of systems
  -- TODO add reduction here for galactic halo addition
  count = math.floor love.math.randomNormal radius^0.51, count -- varrying the density a little randomly sounds fun :3
  print "#{count} systems will be generated (within #{radius}ly)"

  rings = {}
  -- created as needed now (but table.sort hates this)
  -- for i = 0, radius + 1 -- intentionally including out of scope by 1 in case I messed up the scope
  --   rings[i] = 0
  for i = 0, 100000 -- intentionally rediculous, so that there can't possibly be nil elements (should never need to be above 10k)
    rings[i] = 0

  for i = 1, count
    -- from https://stackoverflow.com/a/5838055
    t = love.math.random! * math.pi * 2
    u = love.math.random! + love.math.random!
    r = u
    r = 2 - u if u > 1
    if love.math.random! > 1 - 0.0567 * r - 0.933 * r^2
    -- if love.math.random! > 1 - 0.453 * r - 0.546 * r^2 (too dramatic?)
    -- if love.math.random! > 1 -1.31 * r + 0.312 * r^2 -- (I like this IF ONLY THE RADIUS IS LARGER BY 15%)
      continue
    r2 = r * radius
    x, y = r2 * math.cos(t), r2 * math.sin(t)
    table.insert(systems, {:x, :y, r: r2, a: t})
    r3 = math.floor r2
    rings[r3] = 0 if not rings[r3]
    rings[r3] += 1

  -- I think density should be close to double in the bulge area
  radius2 = radius / love.math.randomNormal 0.1, 6.67
  count2 = math.floor math.pi * radius2^2 * 2.03e-3
  count2 = math.floor love.math.randomNormal radius2^0.49, count2
  print "#{count2} extra systems in the bulge (radius: #{radius2})"
  for i = 1, count2
    t = love.math.random! * math.pi * 2
    u = love.math.random! + love.math.random!
    r = u
    r2 = r * radius2
    x, y = r2 * math.cos(t), r2 * math.sin(t)
    table.insert(systems, {:x, :y, r: r2, a: t})
    -- rings[math.floor(r2)] += 1
    r3 = math.floor r2
    rings[r3] = 0 if not rings[r3]
    rings[r3] += 1

  -- let's add a very sparsely populated halo :D
  radius3 = radius + radius * math.abs love.math.randomNormal 0.1, 0.5
  for i = 0, math.floor(radius3) + 1 -- hopefully this unbreaks our sorting attempt..
    rings[i] = 0 if not rings[i]
  count3 = math.floor math.pi * radius3^2 * 2.03e-5
  count3 = math.floor love.math.randomNormal radius3^0.49, count3
  print "#{count3} extra systems in the halo (radius: #{radius3})"
  for i = 1, count3
    t = love.math.random! * math.pi * 2
    u = love.math.random! + love.math.random!
    r = u
    r2 = r * radius3
    x, y = r2 * math.cos(t), r2 * math.sin(t)
    table.insert(systems, {:x, :y, r: r2, a: t})
    r3 = math.floor r2
    rings[r3] = 0 if not rings[r3]
    rings[r3] += 1

  -- total_count = count + count2
  total_count = count + count2 + count3

  export max_ring, which_ring = 0, -1 -- fucking ridiculously lazy :D
  if export_data
    export file = io.open("plurality.txt", "w")
    assert file, "Failed to create/open 'plurality.txt'."
  -- for i = 0, radius + 1
  --   ring = rings[i]
  --   continue if not ring
  for index, ring in pairs rings
    -- print(ring)
    file\write("#{ring}\n") if export_data
    if ring > max_ring
      max_ring = ring
      which_ring = index
  file\close! if export_data
  -- NOTE exact radius of systems should be checked against each other to remove too close approaches on a longer timescale
  --   because we generate a large number of systems, just delete the last one in the list of offending pairs
  -- NOTE in the future, we need to check for systems within a ly of each other (in initial state) and delete the last one from each pair
  --   loading process can be sped up on subsequent generations of a galaxy by caching removed system IDs

  max_systems_displayed = 0
  -- table.sort rings, (a, b) ->
  --   return false if a == nil
  --   return true if b == nil
  --   return a > b
  table.sort rings, (a, b) -> a > b
  for i = 1, 1102 -- zoom level 1 max distance displayed
    max_systems_displayed += rings[i]

  print "#{max_systems_displayed} systems might have to be displayed at once (estimate)"

  -- distribution of multi-star systems experiment
  star_counts = {}
  for i = 1, total_count
    c = math.floor love.math.randomNormal 1.7, 0.9 -- standard deviation and mean are flipped from original intent, but work better this way
    -- c = math.floor love.math.randomNormal 0.9, 1.7
    c = math.floor(love.math.random! * 2) + 1 if c < 1
    star_counts[c] = 0 if not star_counts[c]
    star_counts[c] += 1
  -- deliberate skew!
  if not star_counts[9]
    if love.math.random! > 0.9
      -- choose a system from the 1's randomly and make it a 9
      star_counts[9] = 1
      star_counts[1] -= 1
  for k, v in pairs star_counts
    print("#{v} star systems will have #{k} stars")

  system_colors = {}
  -- O, B, A, F, G, K, M L
  system_rarities = { -- NOTE these rarities need to eventually be per star, not per system
    O: 0.01 -- 0.00003% in halo, 0.003% in disk, 0.01% in core (& mk sure > 0 at end of generation)
    B: 0.13
    A: 0.6
    F: 3
    G: 7.6
    K: 12.1
    M: 76.45
    L: 0.11 -- do 30% in halo, 18% in disk, 0.11% in core
  }
  for system_type in pairs system_rarities
    system_colors[system_type] = {}
  for system in *systems
    system_type = lume.weightedchoice system_rarities
    table.insert system_colors[system_type], system

  total_systems = #systems
  for key, systems_type in pairs system_colors
    count = #systems_type
    percentage = count / total_systems
    print "#{key}: #{percentage * 100}% (#{count}/#{total_systems}) (intended: #{system_rarities[key]}%)"

areatest.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

colors = {
  O: {0.521, 0.521, 0.996, 1}
  B: {0.701, 0.898, 1, 1}
  A: {1, 1, 1, 1}
  F: {1, 0.996, 0.780, 1}
  G: {0.988, 0.972, 0.250, 1}
  K: {0.905, 0.549, 0.015, 1}
  M: {0.847, 0.011, 0.031, 1}
  L: {0.302, 0.187, 0.177, 1}
}
scale, scale_opts = 1, {0.1, 0.02, 0.06}
areatest.draw = =>
  fontSize = love.graphics.getFont!\getHeight!
  love.graphics.setColor 1, 1, 1, 1
  love.graphics.print "esc: Exit/Return to main menu.", 1, h - (fontSize + 1)
  love.graphics.print "Radius #{which_ring} has #{max_ring} systems.", 1, h - (fontSize + 1) * 2

  love.graphics.translate w / 2, h / 2
  love.graphics.scale scale_opts[scale] -- 0.02 to see halo, 0.06 for just disk, 0.1 makes the bulge noticeable

  for key, system_type in pairs system_colors
    love.graphics.setColor colors[key]
    for system in *system_type
      love.graphics.points system.x, system.y

areatest.keypressed = (key) =>
  switch key
    when "escape"
      Gamestate.pop!
    when "s"
      scale += 1
      scale = 1 if scale > #scale_opts

return areatest
