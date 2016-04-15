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
local utils= require('lib.utils')

-- MODULE DECLARATION ----------------------------------------------------------

-- MODULE OBJECT CONSTRUCTOR ---------------------------------------------------

local Diver = soop.class(Entity)

-- LOCAL CONSTANTS -------------------------------------------------------------

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- MODULE FUNCTIONS ------------------------------------------------------------

function Diver:initialize(entities, parameters)
--  self.__base:initialize(parameters)
  local base = self.__base
  base.initialize(self, parameters)
  
  self.entities = entities
  self.type = 'foe'
  self.priority = 2
  self.radius = 13
  self.speed = parameters.speed
  self.points = parameters.points
  self.life = parameters.life
  self.target = self.position
end

function Diver:update(dt)
  local distance = utils.distance(self.position, self.target)
  
  if distance <= self.radius then
    local x, y = unpack(self.position)
    local tx, ty = love.math.random(constants.SCREEN_WIDTH) - 1, love.math.random(constants.SCREEN_HEIGHT) - 1
    self.angle = math.atan2(ty - y, tx - x)
    self.target = { tx, ty }
  end

  self.position = { self:cast(self.speed * dt) }
end

function Diver:draw()
  if not self:is_alive() then
    return
  end
  
  local cx, cy = unpack(self.position)
  graphics.circle(cx, cy, self.radius, 'purple')
--  local tx, ty = unpack(self.target)
--  graphics.circle(tx, ty, 1, 'purple')
end

-- END OF MODULE ---------------------------------------------------------------

return Diver

-- END OF FILE -----------------------------------------------------------------
