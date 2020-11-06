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

-- Убрать
function Player:addSpeedInDirection(acceleration, direction)
    -- Блок накидывания скорости объекту
    local changeSpeedVector = Vector(direction.x * acceleration.x, direction.y * acceleration.y)
    if direction.x * (self.velocity.x + changeSpeedVector.x) <= self.maxSpeed then
        self.velocity.x = self.velocity.x + changeSpeedVector.x
    else
        self.velocity.x = direction.x * self.maxSpeed
    end
    self.velocity.y = self.velocity.y + changeSpeedVector.y

    -- Блок снижения скорости (гравитация и трение о поверхность воздух, вся фигня)
    local slowDownDirection = self.velocity.x >= 0 and -1 or 1
    if -slowDownDirection * (self.velocity.x + slowDownDirection * self.slowDownSpeed ) > 0 then
        self.velocity.x = self.velocity.x + slowDownDirection * self.slowDownSpeed
    else
        self.velocity.x = 0
    end

    if not self.isGrounded and self.velocity.y <= self.maxSpeed  then
        self.velocity = self.velocity + self.gravity
    end
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
