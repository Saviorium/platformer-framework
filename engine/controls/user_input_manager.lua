local Class = require "lib.hump.class"
local Vector = require "lib.hump.vector"
local Baton = require "lib.baton.baton"
local InputGenerator = require "engine.controls.input_generator"

local UserInputManager = Class {
    __includes = InputGenerator,
    init = function(self, inputConfig)
        InputGenerator.init(self)
        self.inputConfig = inputConfig
        self.batonInstance = Baton.new(self.inputConfig)
    end
}

function UserInputManager:update(dt)
    self.batonInstance:update()
    self.inputSnapshot = self:_saveInputSnapshot()
end

function UserInputManager:_saveInputSnapshot()
    local snapshot = {}
    for command, _ in pairs(self.inputConfig.controls) do
        snapshot[command] = self.batonInstance:get(command)
    end
    for inputPair, _ in pairs(self.inputConfig.pairs) do
        local x, y = self.batonInstance:get(inputPair)
        snapshot[inputPair] = Vector(x, y)
    end
    return snapshot
end

return UserInputManager
