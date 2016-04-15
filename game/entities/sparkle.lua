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
local easing = require('lib.easing')
local soop = require('lib.soop')

-- MODULE DECLARATION ----------------------------------------------------------

-- MODULE OBJECT CONSTRUCTOR ---------------------------------------------------

local Sparkle = soop.class(Entity)

-- LOCAL CONSTANTS -------------------------------------------------------------

local TINTS = { 'brown', 'orange', 'red', 'yellow', 'white' }

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- MODULE FUNCTIONS ------------------------------------------------------------

function Sparkle:initialize(entities, parameters)
--  self.__base:initialize(parameters)
  local base = self.__base
  base.initialize(self, parameters)
  
  self.entities = entities
  self.type = 'sparkle'
  self.priority = 3
  self.ephemeral = true
  self.radius = parameters.radius
  self.speed = parameters.speed
  self.life = parameters.life
  self.reference = parameters.life
end

function Sparkle:update(dt)
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

function Sparkle:draw()
  if self.life <= 0 then
    return
  end

  -- This is used to track the (normalized) particle age.
  local alpha = self.life / self.reference

  -- We determine the current color, based on the sparkle age. Note that
  -- this is a bit convoluted due to the Lua 1-based indices.
  local color = TINTS[math.floor((#TINTS - 1) * easing.cubic(alpha)) + 1]

  -- Draw the sparkle, by casting the trail scaling the speed to 1/20th in
  -- order to get the length of the sparkle trail. Needs to be least one
  -- pixel long.
  local cx, cy = unpack(self.position)
  local trail = math.max(1, self.speed / 20)
  local x, y = self:cast(trail)
  graphics.line(cx, cy, x, y, color, easing.hill(alpha) * 255)
end

-- END OF MODULE ---------------------------------------------------------------

return Sparkle

-- END OF FILE -----------------------------------------------------------------
