local Class = require "lib.hump.class"
local Vector = require "lib.hump.vector"
local DummyAnimator = require "game.test_objects.animated_dummy.dummy_animator"

local AnimatedDummy = Class { -- TODO: I am temporary - delete me
    init = function(self, x, y)
        self.position = Vector(x, y)
        self.animator = DummyAnimator(AssetManager:getAnimation("player"))
        self.animator:setVariable("speed", 0)
        self.speed = 0
    end
}

function AnimatedDummy:update(dt)
    self.animator:update(dt)
    self.speed = self.speed / 2
    self.animator:setVariable("speed", self.speed)
end

function AnimatedDummy:move()
    self.speed = 1
end

function AnimatedDummy:draw()
    self.animator:draw(self.position.x, self.position.y)
end

return AnimatedDummy
