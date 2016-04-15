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
local constants = require('game.constants')
local graphics = require('lib.graphics')
local soop = require('lib.soop')

-- MODULE DECLARATION ----------------------------------------------------------
-- MODULE OBJECT CONSTRUCTOR ---------------------------------------------------

local Spouter = soop.class(Entity)

-- LOCAL CONSTANTS -------------------------------------------------------------

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- MODULE FUNCTIONS ------------------------------------------------------------

function Spouter:initialize(entities, parameters)
--  self.__base:initialize(parameters)
  local base = self.__base
  base.initialize(self, parameters)
  
  self.entities = entities
  self.type = 'foe'
  self.priority = 2
  self.radius = 7
  self.speed = parameters.speed
  self.points = parameters.points
  self.life = parameters.life
  self.bullet_rate = parameters.rate
  self.bullet_counter = 0
  self.wander_rate = parameters.wander
  self.wander_counter = 0
end

function Spouter:update(dt)
  -- If the entity has moved outside the screen, reorient toward the center of
  -- the screen.
  local x, y = unpack(self.position)
  if x < 0 or x >= constants.SCREEN_WIDTH or y < 0 or y >= constants.SCREEN_HEIGHT then
    local cx, cy = unpack(constants.SCREEN_CENTER)
    self.angle = math.atan2(cy - y, cx - x)
  end
  
  -- TODO: "WOBBLER": move toward the center of the screen. Once a predetermined distance
  -- is reached, start moving left/right or up/down.
  -- TODO: "ROAMER": move to a target position in the outermost area. Once reached, start
  -- moving around.
  self.bullet_counter = self.bullet_counter + dt
  if self.bullet_counter >= self.bullet_rate then
    self.bullet_counter = 0
  
    -- Pick a random pixel "around" the center of the screen. Then convert the
    -- target position to an angle.
    local cx, cy = unpack(constants.SCREEN_CENTER)
    local dx, dy = love.math.random(cx - 32, cx + 32), love.math.random(cy - 32, cy + 32)
    local angle = math.atan2(dy - y, dx - x)
  
    self.entities.world.audio:play('shoot', 0.25) -- FIXME: this is plain ugly!!! :(
    local bullet = self.entities:create('bullet', {
          position = { unpack(self.position) },
          angle = angle,
          is_friendly = false
        })
    self.entities:push(bullet)
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
  self.position = { self:cast(self.speed * dt) }
end

function Spouter:draw()
  if not self:is_alive() then
    return
  end
  
  local cx, cy = unpack(self.position)
  graphics.circle(cx, cy, self.radius, 'yellow')
end

-- END OF MODULE ---------------------------------------------------------------

return Spouter

-- END OF FILE -----------------------------------------------------------------
