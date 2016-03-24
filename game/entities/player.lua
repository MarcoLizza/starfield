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

local graphics = require('lib.graphics')

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
    local projectile = entities.create('projectile', { position = { unpack(self.position) }, angle = angle })
    entities.push(projectile)
  end
end

function Player:update(dt)
end

function Player:draw()
  -- Find the facing point on the circle by casting the current position
  -- according to the heading angle.
  local x, y = unpack(self.position)
  x = x + math.cos(self.angle) + self.radius
  y = y + math.sin(self.angle) + self.radius

  graphics.circle(self.position, self.radius, 'white')
  graphics.line(self.position, { x, y }, 'gray')
  graphics.circle({ x, y }, 3, 'red')
end

function Player:reset()
  -- The player is initilized at the center of the screen, facing an arbitrary
  -- direction.
  self.position = {
      math.floor(constants.WORLD_WIDTH / 2),
      math.floor(constants.WORLD_HEIGHT / 2)
    }
  self.angle = 0
  self.radius = 5
  self.health = 10
end

-- END OF MODULE ---------------------------------------------------------------

return Player

-- END OF FILE -----------------------------------------------------------------
