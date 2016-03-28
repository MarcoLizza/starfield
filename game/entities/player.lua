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

local Player = {
}

-- MODULE OBJECT CONSTRUCTOR ---------------------------------------------------

Player.__index = Player

function Player.new()
  local self = setmetatable({}, Player)
  return self
end

-- LOCAL CONSTANTS -------------------------------------------------------------

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- MODULE FUNCTIONS ------------------------------------------------------------

function Player:initialize(world)
  self.world = world
  self.entities = world.entities
  self.type = 'player'
  self.position = { 0, 0 }
  self.angle = 0
  self.radius = 0
  self.health = 0
end

function Player:input(keys, dt)
  local da, shoot = 0, false
  if keys.pressed['left'] then
    da = da - 5
  end
  if keys.pressed['right'] then
    da = da + 5
  end
  if keys.pressed['x'] then
    shoot = true
  end

  -- Update the player heading (angle)
  self.angle = self.angle + da
  
  -- If the player is shooting, spawn a new projectile at the
  -- current player position and with the same angle of direction.
  if shoot then
    local bullet = self.entities:create('bullet', { position = { unpack(self.position) }, angle = self.angle })
    self.entities:push(bullet)
  end
end

function Player:update(dt)
end

function Player:draw()
  -- Find the facing point on the circle by casting the current position
  -- according to the heading angle.
  local angle = utils.to_radians(self.angle)
  
  local cx, cy = unpack(self.position)
  local x = cx + math.cos(angle) * self.radius
  local y = cy + math.sin(angle) * self.radius

  graphics.circle(cx, cy, self.radius, 'white')
--  graphics.line(cx, cy, x, y, 'blue')
  graphics.circle(x, y , 2, 'gray')
end

function Player:reset()
  -- The player is initilized at the center of the screen, facing an arbitrary
  -- direction.
  self.position = {
      math.floor(constants.SCREEN_WIDTH / 2),
      math.floor(constants.SCREEN_HEIGHT / 2)
    }
  self.angle = 0
  self.radius = 5
  self.health = 10
end

-- END OF MODULE ---------------------------------------------------------------

return Player

-- END OF FILE -----------------------------------------------------------------