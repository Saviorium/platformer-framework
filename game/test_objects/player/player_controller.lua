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

    if inputs.up and player.isGrounded then
        player:jump() -- fixme: it's not jumping for now
    elseif inputs.down then
        -- move down faster
    else
        player:killJump()
    end

    moveDirection.x = inputs.move.x

    player:move(moveDirection)
end

return PlayerController
