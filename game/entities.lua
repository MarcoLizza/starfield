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
  projectiles = {}
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
end

function Entities:generate(level)
  self.avatar = { position = { x = 10, y = 10 }, angle = 0, health = 10 }
  self.projectiles = {}
end

function Entities:input(keys)
  local da = 0, shoot = false
  if keys.pressed['up'] then
  end
  if keys.pressed['down'] then
  end
  if keys.pressed['left'] then
    da = da - 5
  end
  if keys.pressed['right'] then
    da = da + 5
  end
  if keys.pressed['x'] then
    shoot = true
  end

  --
  local avatar = self.avatar

  --
  avatar.angle = avatar.angle + da
end

function Entities:update(dt)
end

function Entities:draw()
  local avatar = self.avatar
end

-- END OF MODULE ---------------------------------------------------------------

return Entities

-- END OF FILE -----------------------------------------------------------------
