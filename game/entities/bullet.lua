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

local Entity = require('game.entities.entity')
local graphics = require('lib.graphics')
local soop = require('lib.soop')

-- MODULE DECLARATION ----------------------------------------------------------

-- MODULE OBJECT CONSTRUCTOR ---------------------------------------------------

local Bullet = soop.class(Entity)

-- LOCAL CONSTANTS -------------------------------------------------------------

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- MODULE FUNCTIONS ------------------------------------------------------------

function Bullet:initialize(entities, parameters)
--  self.__base:initialize(parameters)
  local base = self.__base
  base.initialize(self, parameters)
  
  self.entities = entities
  self.type = 'bullet'
  self.priority = 1
  self.is_friendly = parameters.is_friendly
  self.radius = 3
  self.speed = 192
  self.life = 5
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
  self.position = { self:cast(self.speed * dt) }
end

function Bullet:draw()
  if self.life <= 0 then
    return
  end
  
  local color = self.is_friendly and 'cyan' or 'red'
  
  local cx, cy = unpack(self.position)
  graphics.circle(cx, cy, self.radius, color)
end

-- END OF MODULE ---------------------------------------------------------------

return Bullet

-- END OF FILE -----------------------------------------------------------------
