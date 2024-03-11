Gamestate = require "lib.gamestate"
areatest = {}
w, h = 960, 540

export_data = false

systems = {}
areatest.init = =>
  seed = os.time!
  print seed
  -- an exceedingly rare combination arises from the seed 1710196022 (no 8s, a 9, a 10)
  love.math.setRandomSeed seed
  radius = love.math.randomNormal 25, 4500
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
  print "#{count} systems will be generated"

  rings = {}
  -- created as needed now (but table.sort hates this)
  for i = 0, radius + 1 -- intentionally including out of scope by 1 in case I messed up the scope
    rings[i] = 0

  for i = 1, count
    -- from https://stackoverflow.com/a/5838055
    t = love.math.random! * math.pi * 2
    u = love.math.random! + love.math.random!
    r = u
    r = 2 - u if u > 1
    r2 = r * radius
    x, y = r2 * math.cos(t), r2 * math.sin(t)
    table.insert(systems, {:x, :y, r: r2, a: t})
    r3 = math.floor r2
    rings[r3] = 0 if not rings[r3]
    rings[r3] += 1

  -- I think density should be close to double in the bulge area
  radius2 = radius / love.math.randomNormal 0.1, 10
  count2 = math.floor math.pi * radius2^2 * 2.03e-3 / 2.05
  count2 = math.floor love.math.randomNormal radius2^0.49, count2
  print "#{count2} extra systems in the bulge"
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

  total_count = count + count2

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

  table.sort(rings)
  max_systems_displayed = 0
  for i = 1, 1102 -- maximum number of rings possible at zoom level 1
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

areatest.enter = (previous) =>
  width, height, flags = love.window.getMode!
  if width != w or height != h
    love.window.setMode w, h

areatest.draw = =>
  fontSize = love.graphics.getFont!\getHeight!
  love.graphics.print "esc: Exit/Return to main menu.", 1, h - (fontSize + 1)
  love.graphics.print "Radius #{which_ring} has #{max_ring} systems.", 1, h - (fontSize + 1) * 2

  love.graphics.translate w / 2, h / 2
  -- love.graphics.scale 0.06
  for system in *systems
    love.graphics.points system.x, system.y

areatest.keypressed = (key) =>
  switch key
    when "escape"
      Gamestate.pop!

return areatest