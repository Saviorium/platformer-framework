local Class = require "lib.hump.class"
local Vector = require "lib.hump.vector"
local PhysicsObject = require "engine.physics.physics_object"
local PlayerController = require "game.player_controller"

local Player = Class {
    init = function(self, x, y, physicsProcessor)     
        self.collider = physicsProcessor.HC:rectangle(x, y, 35, 25)
        physicsProcessor:registerObject( self, x, y, 'player', 'RigidBody')
        self.controller = PlayerController(self)
        self.direction = Vector(0,0)
    end
}

function Player:update( dt )
    self.controller:update(dt)
end

function Player:draw()
    self:drawDebug()
end

function Player:drawDebug()

    love.graphics.setColor(255, 0, 0)
    if self.deltaVector then
        local normDeltaVector = self.deltaVector:normalized()
        love.graphics.line(
            self.position.x,
            self.position.y,
            self.position.x + normDeltaVector.x * 10,
            self.position.y + normDeltaVector.y * 10
        )
    -- Сделать ещё дебаг
    love.graphics.setColor(0, 0, 255)
        local perpendicularDeltaVector = self.deltaVector:perpendicular():normalized()
        love.graphics.line(
            self.position.x,
            self.position.y,
            self.position.x + perpendicularDeltaVector.x * 10,
            self.position.y + perpendicularDeltaVector.y * 10
        )
    end

    love.graphics.setColor(255, 255, 255)
end


return Player
