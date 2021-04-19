local Class = require "lib.hump.class"
local ObjectController = require "engine.controls.object_controller"

local FlyingEntityController = Class {
    __includes = ObjectController,
    init = function(self, entity, inputManager)
        ObjectController.init(self, inputManager)
        self.entity = entity
        self.inputManager = inputManager
    end
}

function FlyingEntityController:reactToInputs(inputs)
    self.entity:move(Vector(inputs.move.x, inputs.move.y))
end

return FlyingEntityController
