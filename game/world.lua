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

local config = require('game.config')
local constants = require('game.constants')
local Entities = require('game.entities')
local Hud = require('game.hud')

local graphics = require('lib.graphics')

-- MODULE DECLARATION ----------------------------------------------------------

local world = {
}

-- LOCAL CONSTANTS -------------------------------------------------------------

local TINTS = {
  ground = 'peru',
  wall = 'saddlebrown',
  undefined = 'purple'
}

-- MODULE FUNCTIONS ------------------------------------------------------------

function world:initialize()
  self.entities = Entities.new()
  self.entities:initialize(self)

  self.hud = Hud.new()
  self.hud:initialize(self)
end

function world:generate()
  self.level = level -- FIXME: should use global environment or move HUD to the game instance.
  
  -- According to the current level, set a "dusk" period, that is the length
  -- of a "see everything" dimming twilight. From some level onward the twilight
  -- won't be present at all.
  local dusk_period = math.max(0, 10 - level * 0.5)

  self.maze:generate(dusk_period)
  self.entities:generate(level)

  local position = self.entities.avatar.position
  self.maze:spawn_emitter('avatar', position.x, position.y, 5, 3)
end

function world:input(keys)
  self.entities:input(keys)
end

function world:update(dt)
  self.entities:update(dt)
  self.hud:update(dt)
end

function world:draw()
  self.entities:draw()
  self.hud:draw()
end

function world:collide(point, dx, dy) -- Maze:move_to()
  local x, y = point.x, point.y
  local nx, ny = x + dx, y + dy
  -- We cannot move diagonally by design.
  if dy ~= 0 and self.maze:is_walkable(x, ny) then
    point.y = ny
  elseif dx ~=  0 and self.maze:is_walkable(nx, y) then
    point.x = nx
  end
  return point.x ~= x or point.y ~= y
end

-- END OF MODULE -------------------------------------------------------------

return world

-- END OF FILE ---------------------------------------------------------------
