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
local utils = require('lib.utils')

-- MODULE DECLARATION ----------------------------------------------------------

local world = {
}

-- LOCAL CONSTANTS -------------------------------------------------------------

local TINTS = {
  ground = 'peru',
  wall = 'saddlebrown',
  undefined = 'purple'
}

-- LOCAL FUNCTIONS -------------------------------------------------------------

function world:randomize_foe_parameters()
  -- Pick a border and position from which the foe will be spawned.
  local border = love.math.random(4)
  local x, y = 0, 0
  if border == 1 then -- up
    x = love.math.random(self.width) - 1
    y = 0
  elseif border == 2 then -- left
    x = 0
    y = love.math.random(self.height) - 1
  elseif border == 3 then -- down
    x = love.math.random(self.width) - 1
    y = self.height - 1
  elseif border == 4 then -- right
    x = self.width - 1
    y = love.math.random(self.height) - 1
  end
  -- Pick a random pixel "around" the center of the screen. Then convert the
  -- target position to an angle.
  local cx, cy = math.floor(self.width / 2), math.floor(self.height / 2)
  local dx, dy = love.math.random(cx - 32, cx + 32) - 1, love.math.random(cy - 32, cy + 32) - 1
  local atan2 = math.atan2(dy - y, dx - x)
  -- Return the resulting table.
  return {
      position = { x, y },
      angle = utils.to_degrees(atan2),
      speed = love.math.random(32) + 32
    }
end

-- MODULE FUNCTIONS ------------------------------------------------------------

function world:initialize()
  self.width = constants.SCREEN_WIDTH
  self.height = constants.SCREEN_HEIGHT
  self.margin = constants.CELL_SIZE

  self.entities = Entities.new()
  self.entities:initialize(self)

  self.hud = Hud.new()
  self.hud:initialize(self)
  
  self.ticker = 0
end

function world:generate()
  self.entities:generate()
--  self.ticker = 0
end

function world:input(keys)
  self.entities:input(keys)
end

function world:update(dt)
  -- TODO: should resolve collisions HERE, by projecting movements.
  
  self.entities:update(dt)
  self.hud:update(dt)

  -- Find the player entity (we should cache it?)
  local player = self.entities:find(function(entity)
        return entity.type == 'player'
      end)

  -- Scan the entities, resolving collisions with the foes.
  self.entities:iterate(function(entity)
        if entity.type == 'foe' and player:collide(entity) then
          player:hit()
          entity:kill()
          -- TODO: spawn explosion
          return false
        end
        return true
      end)

  -- Spaw a new foe from time to time
  self.ticker = self.ticker + dt
  if self.ticker >= 5 then
    local foe = self.entities:create('foe', self:randomize_foe_parameters())
    self.entities:push(foe)
    self.ticker = 0
  end
end

function world:draw()
  self.entities:draw()
  self.hud:draw()
end

-- END OF MODULE -------------------------------------------------------------

return world

-- END OF FILE ---------------------------------------------------------------
