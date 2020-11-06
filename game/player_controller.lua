local Class = require "lib.hump.class"
local ObjectController = require "engine.controls.object_controller"

local PlayerController = Class {
    __includes = ObjectController,
    init = function(self, player)
        self.player = player
        local commands = {
            up    = function() self.player:jump() end,
            left  = function() self.player:move(-1) end,
            right = function() self.player:move(1) end
        }
        local userInputManager = UserInputManager -- global
        ObjectController.init(self, commands, userInputManager)
    end
}

function PlayerController:reactToInputs(inputs)
    local player = self.player

    -- fixme: I'm lazy. Copypasted from other game
    local moveDirection = Vector(player.direction.x, player.direction.y)

    if inputs.up and (player.isGrounded or player.isHanging) then
        moveDirection.y = -1
        player.isGrounded = false
    elseif inputs.down then
        -- moveDirection.y = 1
    else
        moveDirection.y = 0
    end

    if inputs.right then
        moveDirection.x = 1
    elseif inputs.left then
        moveDirection.x = -1
    else
        moveDirection.x = 0
    end

    player.direction = Vector(moveDirection.x == 0 and player.direction.x or moveDirection.x, moveDirection.y)
    player:addSpeedInDirection( Vector(1, 2), moveDirection)
end

return PlayerController
