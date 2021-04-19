local Class = require "lib.hump.class"

local ObjectController = Class {
    init = function(self, inputGenerator)
        self.inputGenerator = inputGenerator
    end
}

function ObjectController:update(dt)
    local inputs = self.inputGenerator:getInputSnapshot()
    self:reactToInputs(inputs)
end

function ObjectController:reactToInputs(inputSnapshot)
    -- override this
end

return ObjectController
