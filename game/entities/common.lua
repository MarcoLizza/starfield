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

local utils = require('lib.utils')

-- MODULE DECLARATION ----------------------------------------------------------

local common = {
}

-- MODULE FUNCTION -------------------------------------------------------------

function common.cast(self, modulo)
  local angle = utils.to_radians(self.angle)

  local vx = math.cos(angle) * modulo
  local vy = math.sin(angle) * modulo
  
  local cx, cy = unpack(self.position)
  return cx + vx, cy + vy
end

function common.collide(self, other)
  local x0, y0 = unpack(self.position)
  local x1, y1 = unpack(other.position)
  local distance = utils.distance(x0, y0, x1, y1)
  return distance <= (self.radius + other.radius)
end

-- END OF MODULE ---------------------------------------------------------------

return common

-- END OF FILE -----------------------------------------------------------------
