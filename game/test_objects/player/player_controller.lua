local Class = require "lib.hump.class"
local ObjectController = require "engine.controls.object_controller"

local PlayerController = Class {
    __includes = ObjectController,
    init = function(self, player, inputManager)
        ObjectController.init(self, inputManager)
        self.player = player
        self.userInputManager = inputManager
    end
}

function PlayerController:reactToInputs(inputs)
    local player = self.player

    local moveDirection = Vector(player.direction.x, player.direction.y)

    if inputs.up > 0 and player.isGrounded then
        player:jump()
    end
    if inputs.up == 0 then
        player:killJump()
    end

    moveDirection.x = inputs.move.x

    player:move(moveDirection)
end

return PlayerController
