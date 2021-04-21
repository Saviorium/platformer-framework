local Class = require "lib.hump.class"
local Vector = require "lib.hump.vector"
-- Остаётся только для параметров и базового функционала любого физичного объекта, из него не вызываются upadte и draw всякие
local PhysicsObject = Class {
    init = function(self, x, y, gravity, maxVelocity, isColliding, PhysicsProcessor)
        self.position    = Vector( x, y )
        self.velocity    = Vector( 0, 0 )
        self.gravity     = gravity
        self.deltaVector = Vector( 0, 0 )
        self.direction   = Vector(0,0)

        self.isGrounded = false
        self.isColliding = isColliding and isColliding or true

        self.slowDownSpeed = 0.1
        self.maxVelocity     = maxVelocity
        self.maxGroundNormal = 0.05
        self.minGroundNormal = 0.005
        self.minMove         = 0.01
        self.defaultCollisionReaction =
        function(object, delta)
            object.deltaVector = object.deltaVector + delta
        end
        self.addVelocity = PhysicsProcessor.movingProcessor.addAccelerationToObjectAndCalculateFriction
        self.setVelocity = function(self, vector) self.velocity = vector:clone() end
    end
}

return PhysicsObject