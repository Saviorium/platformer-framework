local Vector = require "lib.hump.vector"

if not AssetManager then
    error("AssetManager is required for SoundManager")
end

local SoundEmitter

local SoundManager = {
    soundData = nil,
    listenerPostion = Vector(0, 0),
    listenerVelocity = Vector(0, 0),
    options = {
        maxSources = 100,
        defaultEmitterOptions = {
            maxSources = 3,
            volume = 1,
            volumeVariation = 0,
            pitchVariation = 0,
        }
    },
}

function SoundManager:play(soundName, options)
end

function SoundManager:init(soundData)
    self.soundData = soundData
    return self
end

function SoundManager:newEmitter(soundName, options)
    return SoundEmitter(soundName, options)
end

-- Usage: SoundManager:linkListener(player.position, player.velocity)
function SoundManager:linkListener(listenerPosition, listenerVelocity)
    if type(listenerPostion.x) == number and type(listenerPostion.y) == number then
        self.listenerPostion = listenerPosition
    end
    if type(listenerVelocity.x) == number and type(listenerVelocity.y) == number then
        self.listenerVelocity = listenerVelocity
    end
end

SoundEmitter = Class{
    init = function(soundName, options)
        self.sound = AssetManager:getSound(trackData.soundName)

        self.options = {}
        for k, v in pairs(SoundManager.options.defaultSourceOptions) do
            self.options[k] = v
        end
        self:setOptions(options)
        
        self.sources = {}
    end
}

function SoundEmitter:setOptions(options)
    for k, v in pairs(options) do
        self.options[k] = v
    end
end

function SoundEmitter:play()
end

return function(soundData) return SoundManager:init(soundData) end
