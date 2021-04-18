local Class = require "lib.hump.class"
local Vector = require "lib.hump.vector"
local FlyingEntityController = require "game.test_objects.enemy.flying_entity_controller"
local EnemyAI = require "game.test_objects.enemy.enemy_ai"
local Animator = require "engine.animation.animator"

local Enemy = Class {
    init = function(self, x, y)
        self.position = Vector(x, y)

        self.animator = Animator(AssetManager:getAnimation("blob"))
        self.animator:addSimpleTagState("flying")
        self.animator:addInstantTransition("_start", "flying")

        self.controller = FlyingEntityController(self, EnemyAI.getFlyingEnemyAI(self))

        self.moveSpeed = 5
    end
}

function Enemy:takeControl(inputGenerator)
    self.controller.inputGenerator = inputGenerator
end

function Enemy:move(vector)
    self.position = self.position + vector * self.moveSpeed
end

function Enemy:update( dt )
    self.controller:update(dt)
    self.animator:update(dt)
end

function Enemy:draw()
    self.animator:draw(self.position.x, self.position.y)
end


return Enemy
