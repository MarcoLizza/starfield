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
  local player = entities:find(function(entity)
        return entity.type == 'player'
      end)

  -- Retrieve and display both the player life amount and score.
  local life = math.floor(player and player.life or 0)
  local score = math.floor(world.score)

  -- If the player entity is nowhere to be found, then it's dead. So, overlay
  -- a "GAME OVER" message and bail out!
  if not player then
    graphics.fill('black', 191)
    graphics.text('GAME OVER',
        { 0, 0, constants.SCREEN_WIDTH, constants.SCREEN_HEIGHT },
        'retro-computer', 'white', 'center', 'middle', 3)
    graphics.text(string.format('SCORE: %d', score),
        { 0, 0, constants.SCREEN_WIDTH, constants.SCREEN_HEIGHT * 0.70 },
        'retro-computer', 'white', 'center', 'bottom', 2)
    graphics.text('PRESS Z TO RESTART',
        { 0, 0, constants.SCREEN_WIDTH, constants.SCREEN_HEIGHT * 0.90 },
        'retro-computer', 'white', 'center', 'bottom', 1)
  else
    graphics.text(string.format('LIFE: %d', life),
        { 0, 0, constants.SCREEN_WIDTH, constants.SCREEN_HEIGHT },
        'retro-computer', 'white', 'left', 'bottom', 1)
    graphics.text(string.format('SCORE: %d', score),
        { 0, 0, constants.SCREEN_WIDTH, constants.SCREEN_HEIGHT },
        'retro-computer', 'yellow', 'right', 'bottom', 1)
  end
end

-- END OF MODULE ---------------------------------------------------------------

return Hud

-- END OF FILE -----------------------------------------------------------------
