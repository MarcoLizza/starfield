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
local Foe = require('game.foe')
local graphics = require('lib.graphics')
local utils = require('lib.utils')

-- MODULE DECLARATION ----------------------------------------------------------

local Entities = {
  world = nil,
  avatar = nil,
  foes = {},
  projectiles = {},
  particles = {}
}

-- MODULE OBJECT CONSTRUCTOR ---------------------------------------------------

Entities.__index = Entities

function Entities.new()
  local self = setmetatable({}, Entities)
  return self
end

-- LOCAL FUNCTIONS -------------------------------------------------------------

local function integrate(position, velocity, dt)
  local x, y = unpack(position)
  local vx, vy = unpack(velocity)
  return { x = x + vx * dt, y = y + vy * dt }
end

-- MODULE FUNCTIONS ------------------------------------------------------------

function Entities:initialize(world)
  self.world = world
  
  self.player = Player.new()
  self.player:initialize(world)
end

function Entities:generate(level)
  self.player:reset()
  self.projectiles = {}
end

function Entities:input(keys, dt)
  for _, entity in pairs(self.entities) do
    entity.input(keys, dt)
  end
end

function Entities:update(dt)
  local zombies = {}
  local exploded = {}
  for id, projectile in pairs(self.projectiles) do
    local is_dead = true
    projectile.life = projectile.life - dt
    if projectile.life > 0 then
      local position = integrate(projectile.position, projectile.velocity, dt)
      if not raycast(projectile.position, position,
          function(position)
            -- Check if the point at the current position is occupied by a foe.
            for id, foe in pairs(foes) do
              if not exploded[id] and utils.distance(position, foe.position) <= foe.radius then
                exploded[#exploded + 1] = id
                return true
              end
            end
            return false
          end) then
        is_dead = false
      end
    end
    if is_dead then
      zombies[#zombies + 1] = id
    end
  end
  
  for _, id in ipairs(zombies) do
    self.projectiles[id] = nil
  end

  for _, id in ipairs(exploded) do
    local foe = self.projectiles[id]
    -- SPAWN AN EXPLOSION
    self.projectiles[id] = nil
  end
end

function Entities:draw()
  local avatar = self.avatar
end

function Entities:create(type, parameters)
  return nil
end

function Entities:push(entity)
end

-- END OF MODULE ---------------------------------------------------------------

return Entities

-- END OF FILE -----------------------------------------------------------------
