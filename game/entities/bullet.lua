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

local Bullet = {
}

-- MODULE OBJECT CONSTRUCTOR ---------------------------------------------------

Bullet.__index = Bullet

function Bullet.new()
  local self = setmetatable({}, Bullet)
  return self
end

-- LOCAL CONSTANTS -------------------------------------------------------------

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- MODULE FUNCTIONS ------------------------------------------------------------

function Bullet:initialize(entities, parameters)
  self.entities = entities
  self.type = 'bullet'
  self.position = parameters.position
  self.angle = parameters.angle
  self.is_friendly = parameters.is_friendly
  self.radius = 3
  self.speed = 128
  self.life = 5
end

function Bullet:input(keys, dt)
end

function Bullet:update(dt)
  -- Decrease the current bullet life. If "dead" bail out.
  if self.life > 0 then
    self.life = self.life - dt
  end
  if self.life <= 0 then
    return
  end
  
  -- Compute the current bullet velocity and update its position.
  self.position = { common.cast(self, self.speed * dt) }
end

function Bullet:draw()
  if self.life <= 0 then
    return
  end
  
  local cx, cy = unpack(self.position)
  graphics.circle(cx, cy, self.radius, 'red')
end

function Bullet:hit()
end

function Bullet:kill()
  self.life = 0
end

function Bullet:is_alive()
  return self.life > 0
end

-- END OF MODULE ---------------------------------------------------------------

return Bullet

-- END OF FILE -----------------------------------------------------------------
