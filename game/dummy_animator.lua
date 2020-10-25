local Class = require "lib.hump.class"
local Animator = require "engine.animator"
local AnimationState = require "engine.animation_state"
local AnimationStates = require "game.dummy_animation_states"

DummyAnimator = Class {
    __includes = Animator,
    init = function(self, animationSprite)
        Animator.init(self, animationSprite)
        for _, state in pairs(AnimationStates) do
            self:addState(state(self))
        end
        --vardump(getmetatable(self))
        self:addTransition("idle", "running", self.isRunning)
        self:addTransition("running", "stopping", self.isStopped)
        self:addTransition("stopping", "idle", function() return self:isStopped() and self:isLooped() end)
        self:addTransition("_start", "idle", function() return true end)
    end
}

function DummyAnimator:isRunning()
    if self:getVariable("speed") > 0.1 then
        return true
    end
    return false
end

function DummyAnimator:isStopped()
    if self:getVariable("speed") < 0.1 then
        return true
    end
    return false
end

return DummyAnimator