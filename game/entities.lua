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
local Player = require('game.entities.player')
local Bullet = require('game.entities.bullet')
local Diver = require('game.entities.diver')
local Spouter = require('game.entities.spouter')
local Smoke = require('game.entities.smoke')
local Sparkle = require('game.entities.sparkle')
local Bubble = require('game.entities.bubble')

-- MODULE DECLARATION ----------------------------------------------------------

local Entities = {
}

-- MODULE OBJECT CONSTRUCTOR ---------------------------------------------------

Entities.__index = Entities

function Entities.new()
  local self = setmetatable({}, Entities)
  return self
end

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- MODULE FUNCTIONS ------------------------------------------------------------

function Entities:initialize(world)
  self.world = world
  self.entities = {}
end

function Entities:reset()
  self.entities = {}
  local player = self:create('player', {
      position = { unpack(constants.SCREEN_CENTER) },
      angle = 0
    })
  self:push(player)
end

function Entities:update(dt)
  -- Update and keep track of the entities that supports life-querying
  -- and need to be removed.
  --
  -- Since we need to keep the entities list sorted, we remove "dead"
  -- entities from the back to front. To achive this we "push" the
  -- indices at the front of the to-be-removed list. That way, when
  -- we traverse it we can safely remove the elements as we go.
  local zombies = {}
  for index, entity in ipairs(self.entities) do
    entity:update(dt)
    if entity.is_alive and not entity:is_alive() then
      table.insert(zombies, 1, index);
    end
  end
  for _, index in ipairs(zombies) do
    table.remove(self.entities, index)
  end
end

function Entities:draw()
  table.sort(self.entities, function(a, b)
        return a.priority < b.priority
      end)
  
  for _, entity in pairs(self.entities) do
    entity:draw()
  end
end

function Entities:create(type, parameters)
  if type == 'player' then
    local player = Player.new()
    player:initialize(self, parameters)
    return player
  elseif type == 'spouter' then
    local foe = Spouter.new()
    foe:initialize(self, parameters)
    return foe
  elseif type == 'diver' then
    local foe = Diver.new()
    foe:initialize(self, parameters)
    return foe
  elseif type == 'bullet' then
    local bullet = Bullet.new()
    bullet:initialize(self, parameters)
    return bullet
  elseif type == 'sparkle' then
    local sparkle = Sparkle.new()
    sparkle:initialize(self, parameters)
    return sparkle
  elseif type == 'smoke' then
    local smoke = Smoke.new()
    smoke:initialize(self, parameters)
    return smoke
  elseif type == 'bubble' then
    local bubble = Bubble.new()
    bubble:initialize(self, parameters)
    return bubble
  end
  return nil
end

function Entities:push(entity)
  -- Using the "table" namespace functions since we are continously
  -- scambling the content by reordering it.
  table.insert(self.entities, entity)
end

function Entities:iterate(callback)
  local length = #self.entities
  for index = 1, length do
    local entity = self.entities[index]
    if not callback(entity) then
      break
    end
  end
end

function Entities:select(filter)
  local entities = {}
  for _, entity in ipairs(self.entities) do
    if filter(entity) then
      entities[#entities + 1] = entity
    end
  end
  return entities
end

function Entities:find(filter)
  for _, entity in ipairs(self.entities) do
    if filter(entity) then
      return entity
    end
  end
  return nil
end

-- END OF MODULE ---------------------------------------------------------------

return Entities

-- END OF FILE -----------------------------------------------------------------
