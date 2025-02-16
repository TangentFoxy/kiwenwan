--
-- classic
--
-- Copyright (c) 2014, rxi
-- Copyright (c) 2020, Astie Teddy (TSnake41)
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.
--
-- Lynx version, with some modifications.
--


local Object = {}
Object.__index = Object

function Object:new()
end

function Object:extend()
  local cls = {}

  for k, v in pairs(self) do
    if k:find("__") == 1 then
      cls[k] = v
    end
  end

  cls.__index = cls
  cls.super = self

  return setmetatable(cls, self)
end

function Object:implement(...)
  for _, cls in pairs { ... } do
    for k, v in pairs(cls) do
      if self[k] == nil then
        self[k] = v
      end
    end
  end
end

function Object:is(T)
  local mt = getmetatable(self)
  while mt do
    if mt == T then
      return true
    end
    mt = getmetatable(mt)
  end
  return false
end

function Object:__tostring()
  return "Object"
end

function Object:__call(...)
  local obj = setmetatable({}, self)
  obj:new(...)
  return obj
end

return Object
