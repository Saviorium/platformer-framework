local PhysicsObject = require "engine.physics.physics_object"

local Player =
Class {
    init = function(self, x, y, PhysicsProcessor)
        self.collider = PhysicsProcessor.HC:rectangle(x, y, 35, 25)
        PhysicsProcessor:registerObject( self, x, y, 'player', 'RigidBody')
    end
}


function Player:update( dt )
end

function Player:draw()
    self:drawDebug()
end

function Player:drawDebug()

    love.graphics.setColor(255, 0, 0)
    if self.deltaVector then
        print(self.position, self.deltaVector )
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
