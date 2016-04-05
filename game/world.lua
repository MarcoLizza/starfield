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
local Entities = require('game.entities')
local Hud = require('game.hud')
local utils = require('lib.utils')

-- MODULE DECLARATION ----------------------------------------------------------

local world = {
}

-- LOCAL CONSTANTS -------------------------------------------------------------

local TINTS = { 'yellow', 'red', 'orange' }

local SMOKES = { 'white', 'lightgray', 'gray', 'darkgray' }

-- LOCAL FUNCTIONS -------------------------------------------------------------

function world:generate_sparkles(position)
  local amount = love.math.random(4) + 3
  for _ = 1, amount do
    local parameters = {
      position = { unpack(position) },
      angle = love.math.random(360) - 1,
      radius = 1,
      speed = love.math.random(64) + 64,
      life = (love.math.random(2) + 1) / 3,
      color = TINTS[love.math.random(#TINTS)]
    }
    local sparkle = self.entities:create('sparkle', parameters)
    self.entities:push(sparkle)
  end
end

function world:generate_explosion(position)
  local angle = love.math.random(360) - 1
  for i = 0, 15 do -- two full rounds, to generate twin smokes
    local parameters = {
      position = { unpack(position) },
      angle = angle + i  * 45,
      radius = love.math.random(6) + 3,
      speed = love.math.random(16) + 16,
      life = (love.math.random(5) + 1) / 3,
      color = SMOKES[love.math.random(#SMOKES)]
    }
    local debris = self.entities:create('sparkle', parameters) -- debris shrink with age
    self.entities:push(debris)
  end
end

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
      speed = love.math.random(32) + 32,
      rate = 5,
      wander = 2
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
          entity:kill()
          player:hit()
          self:generate_explosion(entity.position)
          if not player:is_alive() then
            self:generate_explosion(player.position)
          end
        end
        if entity.type == 'bullet' and not entity.is_friendly and player:collide(entity) then
          entity:kill()
          player:hit()
          self:generate_sparkles(entity.position)
          if not player:is_alive() then
            self:generate_explosion(player.position)
          end
        end
        return true -- always continue, we need to consider all the collisions!
      end)

  -- Scan the enemies, and check if one of the player bullets hit
  -- them.
  local bullets = self.entities:select(function(entity)
        return entity.type == 'bullet' and entity.is_friendly
      end)
  
  self.entities:iterate(function(entity)
        if entity.type == 'foe' then
          for _, bullet in pairs(bullets) do
            if entity:collide(bullet) then
              bullet:kill()
              entity:hit()
              self:generate_sparkles(bullet.position)
              if not entity:is_alive() then
                self:generate_explosion(entity.position)
              end
            end
          end
        end
        return true
      end)

  -- Spaw a new foe from time to time
  self.ticker = self.ticker + dt
  if self.ticker >= 5 then
--    local foe = self.entities:create('foe', self:randomize_foe_parameters())
    local foe = self.entities:create('spouter', self:randomize_foe_parameters())
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
