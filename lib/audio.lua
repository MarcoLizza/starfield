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

-- MODULE DECLARATION ----------------------------------------------------------

local Audio = {
}

-- MODULE OBJECT CONSTRUCTOR ---------------------------------------------------

Audio.__index = Audio

function Audio.new()
  local self = setmetatable({}, Audio)
  return self
end

-- LOCAL CONSTANTS -------------------------------------------------------------

-- LOCAL FUNCTIONS -------------------------------------------------------------

-- MODULE FUNCTIONS ------------------------------------------------------------

function Audio:initialize(sounds)
  self.sounds = {}
  for id, sound in pairs(sounds) do
    local source = love.audio.newSource(sound, 'static')
    self.sounds[id] = source
  end
end

function Audio:halt()
end

function Audio:play(id, volume)
  local source = self.sounds[id]
  if source then
    -- TODO: clone the sound and play it?
    source:setVolume(volume or 1.0)
    if source:isPlaying() then
      source:rewind()
    else
      source:play()
    end
  end
end

-- END OF MODULE ---------------------------------------------------------------

return Audio

-- END OF FILE -----------------------------------------------------------------
