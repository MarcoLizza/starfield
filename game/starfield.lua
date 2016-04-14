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
local graphics = require('lib.graphics')

-- MODULE DECLARATION ----------------------------------------------------------

local Starfield = {
}

-- MODULE OBJECT CONSTRUCTOR ---------------------------------------------------

Starfield.__index = Starfield

function Starfield.new()
  local self = setmetatable({}, Starfield)
  return self
end

-- LOCAL CONSTANTS -------------------------------------------------------------

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- MODULE FUNCTIONS ------------------------------------------------------------

function Starfield:initialize()
  self.angle = 0
  self.ticker = 0
  self.layers = {}
  local steps = config.starfield.layers - 1
  local step = (config.starfield.max_speed - config.starfield.min_speed) / steps
  for i = 1, config.starfield.layers do
    local layer = {
        speed = step * (i - 1) + config.starfield.min_speed,
        alpha = (255 / steps) * (i - 1),
        stars = {}
      }
    for _ = 1, config.starfield.stars_per_layer do
      layer.stars[#layer.stars + 1] = {
          position = { love.math.random(constants.SCREEN_WIDTH), love.math.random(constants.SCREEN_HEIGHT) }
        }
    end
    self.layers[#self.layers + 1] = layer
  end
end

function Starfield:update(dt)
  self.ticker = self.ticker + dt
  if self.ticker >= config.starfield.reorient_timeout then
    self.angle = love.math.random() * 2 * math.pi
    self.ticker = 0
  end

  local vx, vy = math.cos(self.angle), math.sin(self.angle)

  for _, layer in ipairs(self.layers) do
    local speed = layer.speed * dt
    for _, star in ipairs(layer.stars) do
      local x, y = unpack(star.position)
      local nx, ny = x + vx * speed, y + vy * speed
      nx = (nx + constants.SCREEN_WIDTH) % constants.SCREEN_WIDTH
      ny = (ny + constants.SCREEN_WIDTH) % constants.SCREEN_WIDTH
      star.position = { nx, ny }
    end
  end
end

function Starfield:draw()
  for _, layer in ipairs(self.layers) do
    for _, star in ipairs(layer.stars) do
      local x, y = unpack(star.position)
      -- We are drawing the stars as squares, since "love.graphics.points"
      -- is not autoscaled (obviously).
      graphics.square(x, y, 1, 'lightcyan', layer.alpha)
    end
  end
end

-- END OF MODULE ---------------------------------------------------------------

return Starfield

-- END OF FILE -----------------------------------------------------------------
