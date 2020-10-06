local Vector = require "lib.hump.vector"
local Class = require "lib.hump.class"

if not AssetManager then
    error("AssetManager is required for SoundManager")
end

local SoundEmitter

local SoundManager = {
    soundConfig = nil,
    listenerPostion = Vector(0, 0),
    listenerVelocity = Vector(0, 0),
    emitters = {},
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
    self.emitters[soundName]:play(options)
end

function SoundManager:init(soundConfig)
    self.soundConfig = soundConfig
    for soundName, soundData in pairs(soundConfig) do
        self.emitters[soundName] = self:newEmitter(soundData)
    end
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
    init = function(self, soundData)
        self.soundFiles = soundData.files

        self.options = {}
        for k, v in pairs(SoundManager.options.defaultEmitterOptions) do
            self.options[k] = v
        end
        self:setOptions(soundData.options)
        
        self.sources = {}
    end
}

function SoundEmitter:setOptions(options)
    for k, v in pairs(options) do
        self.options[k] = v
    end
end

function SoundEmitter:play(options)
    if #self.sources < self.options.maxSources then
        self.sources[#self.sources + 1] = {}
    end
    for id, sourceSet in ipairs(self.sources) do
        local source = self:getPlaying(sourceSet)
        if not source then
            local soundFile = self.soundFiles[math.random(#self.soundFiles)].name
            if not sourceSet[soundFile] then
                sourceSet[soundFile] = AssetManager:getSound(soundFile) -- TODO: options
            end
            sourceSet[soundFile]:play()
        end
    end
end

function SoundEmitter:getPlaying(sourceSet)
    for k, source in pairs(sourceSet) do
        if source:isPlaying() then
            return source
        end
    end
    return nil
end

return function(soundData) return SoundManager:init(soundData) end
