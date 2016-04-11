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
local collections = require('lib.collections')
local graphics = require('lib.graphics')
local utils = require('lib.utils')

-- MODULE DECLARATION ----------------------------------------------------------

local Hud = {
}

-- MODULE OBJECT CONSTRUCTOR ---------------------------------------------------

Hud.__index = Hud

function Hud.new()
  local self = setmetatable({}, Hud)
  return self
end

-- LOCAL CONSTANTS -------------------------------------------------------------

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- MODULE FUNCTIONS ------------------------------------------------------------

function Hud:initialize(world)
  self.world = world
end

function Hud:update(dt)
end

function Hud:draw()
  local world = self.world
  local entities = world.entities

  -- Find the player entity (we should cache it?)
  local player = self.entities:find(function(entity)
        return entity.type == 'player'
      end)

  local life = math.floor(player and player.life or 0)
  local points = math.floor(world.points or 0)

  graphics.text(string.format('LIFE: %d', life, 0),
      { 0, constants.SCREEN_HEIGHT * 2 / 3, constants.SCREEN_WIDTH, constants.SCREEN_HEIGHT },
      'silkscreen', 'white', 'bottom', 'left', 2)

  graphics.text(string.format('POINTS: %d', points, 0),
      { 0, constants.SCREEN_HEIGHT * 2 / 3, constants.SCREEN_WIDTH, constants.SCREEN_HEIGHT },
      'silkscreen', 'white', 'bottom', 'right', 2)
end

-- END OF MODULE ---------------------------------------------------------------

return Hud

-- END OF FILE -----------------------------------------------------------------
