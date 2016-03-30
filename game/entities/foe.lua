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
local graphics = require('lib.graphics')
local utils = require('lib.utils')

-- MODULE DECLARATION ----------------------------------------------------------

local Foe = {
}

-- MODULE OBJECT CONSTRUCTOR ---------------------------------------------------

Foe.__index = Foe

function Foe.new()
  local self = setmetatable({}, Foe)
  return self
end

-- LOCAL CONSTANTS -------------------------------------------------------------

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- MODULE FUNCTIONS ------------------------------------------------------------

function Foe:initialize(entities, parameters)
  self.entities = entities
  self.type = 'foe'
  self.position = parameters.position
  self.angle = parameters.angle
  self.radius = 3
  self.speed = parameters.speed
  self.health = 20
end

function Foe:input(keys, dt)
end

function Foe:update(dt)
  -- Compute the current bullet velocity and update its position.
  local angle = utils.to_radians(self.angle)

  local vx = math.cos(angle) * self.speed * dt
  local vy = math.sin(angle) * self.speed * dt
  
  local cx, cy = unpack(self.position)
  self.position = { cx + vx, cy + vy }
end

function Foe:draw()
  if self.health <= 0 then
    return
  end
  
  local cx, cy = unpack(self.position)
  graphics.circle(cx, cy, self.radius, 'yellow')
end

function Foe:is_alive()
  return self.health > 0
end

function Foe:kill()
  self.health = 0
end

-- END OF MODULE ---------------------------------------------------------------

return Foe

-- END OF FILE -----------------------------------------------------------------
