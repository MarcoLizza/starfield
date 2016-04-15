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

local Bubble = soop.class(Entity)

-- LOCAL CONSTANTS -------------------------------------------------------------

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- MODULE FUNCTIONS ------------------------------------------------------------

function Bubble:initialize(entities, parameters)
--  self.__base:initialize(parameters)
  local base = self.__base
  base.initialize(self, parameters)
  
  self.entities = entities
  self.type = 'bubble'
  self.priority = 5
  self.ephemeral = true
  self.speed = parameters.speed
  self.text = parameters.text
  self.color = parameters.color
  self.scale = parameters.scale
  self.life = parameters.life
  self.reference = self.life
end

function Bubble:update(dt)
  -- Decrease the current particle life. If "dead" bail out.
  if self.life > 0 then
    self.life = self.life - dt
  end
  if self.life <= 0 then
    return
  end
  
  -- Compute the current bullet velocity and update its position.
  self.position = { self:cast(self.speed * dt) }
end

function Bubble:draw()
  if self.life <= 0 then
    return
  end
  
  local alpha = self.life / self.reference
  
  local cx, cy = unpack(self.position)
  graphics.text(self.text, { cx, cy },
      'silkscreen', self.color, 'center', 'middle', self.scale, 255 * alpha)
end

-- END OF MODULE ---------------------------------------------------------------

return Bubble

-- END OF FILE -----------------------------------------------------------------
