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

local Spouter = {
}

-- MODULE OBJECT CONSTRUCTOR ---------------------------------------------------

Spouter.__index = Spouter

function Spouter.new()
  local self = setmetatable({}, Spouter)
  return self
end

-- LOCAL CONSTANTS -------------------------------------------------------------

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- MODULE FUNCTIONS ------------------------------------------------------------

function Spouter:initialize(entities, parameters)
  self.entities = entities
  self.type = 'foe'
  self.position = parameters.position
  self.angle = parameters.angle
  self.radius = 3
  self.speed = parameters.speed
  self.health = 20
  self.bullet_rate = parameters.rate
  self.bullet_counter = 0
  self.wander_rate = parameters.wander
  self.wander_counter = 0
end

function Spouter:input(keys, dt)
end

function Spouter:update(dt)
  -- "WOBBLER": move toward the center of the screen. Once a predetermined distance
  -- is reached, start moving left/right or up/down.
  -- "SPOUTER": move to a target position in the outermost area. Once reached, start
  -- moving around.
  self.bullet_counter = self.bullet_counter + dt
  if self.bullet_counter >= self.bullet_rate then
    -- FIXME: Shoot!
    self.bullet_counter = 0
  end

  -- From time to time, change the foe direction. 
  self.wander_counter = self.wander_counter + dt
  if self.wander_counter >= self.wander_rate then
    self.wander_counter = 0
    local ANGLES = { 0, 45, 90, 135, 180, 225, 270, 315 }
--    self.angle = self.angle + love.math.random(-15, 15)
    self.angle = ANGLES[love.math.random(8)]
  end

  -- Compute the current velocity and update the position.
  self.position = { common.cast(self, self.speed * dt) }
end

function Spouter:draw()
  if self.health <= 0 then
    return
  end
  
  local cx, cy = unpack(self.position)
  graphics.circle(cx, cy, self.radius, 'yellow')
end

function Spouter:hit()
  if self.health > 0 then
    self.health = math.max(0, self.health - 1)
  end
end

function Spouter:kill()
  self.health = 0
end

function Spouter:is_alive()
  return self.health > 0
end

-- COMMON FUNCTIONS ------------------------------------------------------------

Spouter.collide = common.collide

-- END OF MODULE ---------------------------------------------------------------

return Spouter

-- END OF FILE -----------------------------------------------------------------
