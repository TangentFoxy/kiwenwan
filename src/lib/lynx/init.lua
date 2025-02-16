local lynx = {}
local path = (...) .. "."

-- Backup old require to replace it with a custom local one.
local _require = require

function require (mod)
  return lynx[mod] or _require(mod)
end

-- All loaded modules, should contain all required stuff.
-- Must to be ordered properly.
local modules = {
  -- Base items
  "classic",
  "menu",
  "item",

  -- Advanced items
  "text",
  "button",
  "slider",
  "observer",
  "list",

  -- Other things
  "love_lynx",
  "raylua_lynx"
}

-- Load stuff.
for i=1,#modules do
  lynx[modules[i]] = _require(path .. modules[i])
end

require = _require

return lynx
