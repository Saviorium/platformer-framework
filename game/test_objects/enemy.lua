local Class = require "lib.hump.class"
local Vector = require "lib.hump.vector"
local EnemyAI = require "game.enemy_ai"
local ObjectController = require "engine.controls.object_controller"
local Animator = require "engine.animator"

Enemy = Class {
    init = function(self, x, y)
        self.position = Vector(x, y)

        self.animator = Animator(AssetManager:getAnimation("blob"))
        self.animator:addSimpleTagState("flying")
        self.animator:addInstantTransition("_start", "flying")

        self.controller = ObjectController(
            {
                up    = function() self:move(-1, 0) end,
                left  = function() self:move(0, -1) end,
                right = function() self:move(0, 1) end,
                down  = function() self:move(1, 0) end
            }, EnemyAI.getFlyingEnemyAI(self)
        )
    end
}

function Enemy:move(dx, dy)
    self.position.x = self.position.x + dx
    self.position.y = self.position.y + dy
end

function Enemy:update( dt )
    self.controller:update(dt)
    self.animator:update(dt)
end

function Enemy:draw()
    self.animator:draw(self.position.x, self.position.y)
end


return Enemy
