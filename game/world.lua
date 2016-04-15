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
local Starfield = require('game.starfield')
local Shaker = require('game.shaker')
local Audio = require('lib.audio')

-- MODULE DECLARATION ----------------------------------------------------------

local world = {
}

-- LOCAL CONSTANTS -------------------------------------------------------------

local SMOKES = { 'white', 'lightgray', 'gray', 'darkgray' }

-- LOCAL FUNCTIONS -------------------------------------------------------------

function world:generate_sparkles(position)
  local amount = math.floor(love.math.random() * 10 + 5)
  for _ = 1, amount do
    -- Sparkles are fast moving and very small in size. They also disappear
    -- quite quickly. The color of the sparkle depends on the "age" of the
    -- particle (white->yellow->orange->red->brown)
    local parameters = {
      position = { unpack(position) },
      angle = love.math.random() * 2 * math.pi,
      radius = 1,
      speed = (love.math.random() * 128) + 64,
      life = (love.math.random() * 1) + 0.5
    }
    local sparkle = self.entities:create('sparkle', parameters)
    self.entities:push(sparkle)
  end
end

function world:generate_explosion(position, amount)
  local step = (2 * math.pi) / amount
  for i = 0, amount do
    local parameters = {
      position = { unpack(position) },
      angle = i  * step,
      radius = love.math.random() * 6 + 3,
      speed = love.math.random() * 16 + 8,
      life = love.math.random() * 3 + 0.5,
      color = SMOKES[love.math.random(#SMOKES)]
    }
    local smoke = self.entities:create('smoke', parameters) -- debris shrink with age
    self.entities:push(smoke)
  end
end

function world:generate_score(position, angle, points)
  -- We determine a "magnitude" factor based on the amunt of points,
  -- so that bigger points will move farther aways, last longer, and
  -- are displayed bigger!
  local factor = math.min(2, math.floor(points / 10))
  local parameters = {
    position = { unpack(position) },
    angle = angle + math.pi, -- bounce back!
    speed = 32 + 16 * factor,
    text = string.format('%d', points),
    color = 'white',
    scale = 2 + factor,
    life = 1 + factor * 0.5
  }
  local score = self.entities:create('bubble', parameters)
  self.entities:push(score)
  self.score = self.score + points
end

function world:generate_damage(position, angle, damage)
  -- We determine a "magnitude" factor based on the amunt of points,
  -- so that bigger points will move farther aways, last longer, and
  -- are displayed bigger!
  local parameters = {
    position = { unpack(position) },
    angle = angle + math.pi, -- bound back!
    speed = 16,
    text = string.format('-%d', damage),
    color = 'red',
    scale = 2,
    life = 1
  }
  local damage = self.entities:create('bubble', parameters)
  self.entities:push(damage)
end

function world:randomize_foe_parameters(kind)
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
  -- FIXME: Pick a random pixel "around" the center of the screen. Then convert the
  -- target position to an angle.
  local cx, cy = math.floor(self.width / 2), math.floor(self.height / 2)
  local dx, dy = love.math.random(cx - 32, cx + 32) - 1, love.math.random(cy - 32, cy + 32) - 1
  local angle = math.atan2(dy - y, dx - x)
  -- Return the resulting table.
  if kind == 'spouter' then
    return {
          position = { x, y },
          angle = angle,
          speed = love.math.random() * 32 + 32,
          life = 7,
          points = 50,
          rate = 5,
          wander = 2
        }
  elseif kind == 'diver' then
    return {
          position = { x, y },
          angle = angle,
          speed = love.math.random() * 16 + 16,
          life = 3,
          points = 10
        }
  else
    return nil
  end
end

-- MODULE FUNCTIONS ------------------------------------------------------------

function world:initialize()
  self.width = constants.SCREEN_WIDTH 
  self.height = constants.SCREEN_HEIGHT 

  self.entities = Entities.new()
  self.entities:initialize(self)

  self.hud = Hud.new()
  self.hud:initialize(self)

  self.starfield = Starfield.new()
  self.starfield:initialize()

  self.shaker = Shaker.new()
  self.shaker:initialize()

  self.audio = Audio.new()
  self.audio:initialize({
      ['explode'] = { file = 'assets/sounds/explosion.wav', overlayed = true, looping = false },
      ['die'] = { file = 'assets/sounds/explosion2.wav', overlayed = true, looping = false },
      ['hit'] = { file = 'assets/sounds/hit.wav', overlayed = true, looping = false },
      ['shoot'] = { file = 'assets/sounds/shoot.wav', overlayed = false, looping = false },
    })

  self.ticker = 0
  self.score = 0
end

function world:reset()
  self.shaker:reset()
  self.entities:reset()
  self.ticker = 0
  self.score = 0
end

function world:input(keys, dt)
  -- Enable restart key only when the player is dead.
  local player = self.entities:find(function(entity)
        return entity.type == 'player'
      end)

  if not player then
    if keys.pressed['z'] then
      self:reset()
    end
  else
    local delta, shoot = 0, false
    if keys.pressed['left'] then
      delta = -player.speed * dt
    end
    if keys.pressed['right'] then
      delta = player.speed * dt
    end
    if keys.pressed['x'] then
      shoot = true
    end

    player:rotate(delta)

    -- If the player is shooting, spawn a new projectile at the
    -- current player position and with the same angle of direction.
    if shoot then
      self.audio:play('shoot', 0.25)
      local bullet = self.entities:create('bullet', {
          position = { unpack(player.position) },
          angle = player.angle,
          is_friendly = true
        })
      self.entities:push(bullet)
    end
  end
end

function world:update(dt)
  self.audio:update(dt)
  self.starfield:update(dt)
  self.shaker:update(dt)
  self.entities:update(dt)
  self.hud:update(dt)

  -- TODO: should resolve collisions HERE, by projecting movements.
  local collisions = self.entities:colliding()
  for _, pair in ipairs(collisions) do
    local this, that = unpack(pair)
    if this.type == 'foe' and that.type == 'bullet' and that.is_friendly then
      this:hit()
      that:kill()
      local points = 5
      self:generate_sparkles(that.position)
      self.audio:play('hit', 0.50)
      self.shaker:add(1)
      if not this:is_alive() then
        points = this .points
        self:generate_explosion(this.position, 16)
        self.audio:play('explode', 0.75)
        self.shaker:add(3)
      end
      self:generate_score(this.position, this.angle, points)
    end
    if this.type == 'player' and that.type == 'foe' then
      this:hit()
      that:kill()
      self:generate_explosion(that.position, 16)
      self.audio:play('explode', 0.75)
      self.shaker:add(3)
      if not this:is_alive() then
        self:generate_explosion(this.position, 32)
        self.audio:play('die')
        self.shaker:add(7)
      end
      self:generate_damage(this.position, this.angle, 1)
    end
    if this.type == 'player' and that.type == 'bullet' and not that.is_friendly then
      this:hit()
      that:kill()
      self:generate_sparkles(that.position)
      self.audio:play('hit', 0.50)
      self.shaker:add(1)
      if not this:is_alive() then
        self:generate_explosion(this.position, 32)
        self.audio:play('die')
        self.shaker:add(7)
      end
      self:generate_damage(this.position, this.angle, 1)
    end
  end

  -- Spaw a new foe from time to time
  self.ticker = self.ticker + dt
  if self.ticker >= 3 then
    local chance = love.math.random(10)
    local kind = chance < 3 and 'spouter' or 'diver'
    local foe = self.entities:create(kind, self:randomize_foe_parameters(kind))
    self.entities:push(foe)
    self.ticker = 0
  end
end

function world:draw()
  self.shaker:pre()
  self.starfield:draw()
  self.entities:draw()
  self.hud:draw()
  self.shaker:post()
end

-- END OF MODULE -------------------------------------------------------------

return world

-- END OF FILE ---------------------------------------------------------------
