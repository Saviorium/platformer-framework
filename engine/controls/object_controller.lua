local Class = require "lib.hump.class"

local ObjectController = Class {
    init = function(self, commandsCallbacks, inputGenerator)
        self.commandsCallbacks = commandsCallbacks
        self.inputGenerator = inputGenerator
    end
}

function ObjectController:update(dt)
    local inputs = self.inputGenerator:getInputSnapshot()
    self:reactToInputs(inputs)
end

function ObjectController:reactToInputs(inputSnapshot)
    for command, callback in pairs(self.commandsCallbacks) do
        if inputSnapshot[command] then
            callback()
        end
    end
end

return ObjectController
