--[[

Copyright (c) 2016 by Marco Lizza (marco.lizza@gmail.com)

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgement in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.

]]--

-- MODULE INCLUSIONS -----------------------------------------------------------

local constants = require('game.constants')
local common = require('game.entities.common')
local graphics = require('lib.graphics')
local utils = require('lib.utils')

-- MODULE DECLARATION ----------------------------------------------------------

local Diver = {
}

-- MODULE OBJECT CONSTRUCTOR ---------------------------------------------------

Diver.__index = Diver

function Diver.new()
  local self = setmetatable({}, Diver)
  return self
end

-- LOCAL CONSTANTS -------------------------------------------------------------

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- MODULE FUNCTIONS ------------------------------------------------------------

function Diver:initialize(entities, parameters)
  self.entities = entities
  self.type = 'foe'
  self.position = parameters.position
  self.angle = parameters.angle
  self.radius = 3
  self.speed = parameters.speed
  self.health = 20
end

function Diver:input(keys, dt)
end

function Diver:update(dt)
  -- Compute the current velocity and update the position.
  self.position = { common.cast(self, self.speed * dt) }
end

function Diver:draw()
  if self.health <= 0 then
    return
  end
  
  local cx, cy = unpack(self.position)
  graphics.circle(cx, cy, self.radius, 'yellow')
end

function Diver:hit()
  if self.health > 0 then
    self.health = math.max(0, self.health - 1)
  end
end

function Diver:kill()
  self.health = 0
end

function Diver:is_alive()
  return self.health > 0
end

-- COMMON FUNCTIONS ------------------------------------------------------------

Diver.collide = common.collide

-- END OF MODULE ---------------------------------------------------------------

return Diver

-- END OF FILE -----------------------------------------------------------------
