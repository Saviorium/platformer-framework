local Class = require "lib.hump.class"
local Animator = require "engine.animator"
local AnimationState = require "engine.animation_state"

local AnimationStates = {
    running = function(animator)
        return animator:createSimpleTagState("running", "run")
    end,
    stopping = function(animator)
        return animator:createSimpleTagState("stopping", "brake")
    end,
    idle = function(animator)
        return animator:createSimpleTagState("idle", "idle")
    end,
}

local DummyAnimator = Class {
    __includes = Animator,
    init = function(self, animationSprite)
        Animator.init(self, animationSprite)
        for _, state in pairs(AnimationStates) do
            self:addState(state(self))
        end
        --vardump(getmetatable(self))
        self:addTransition("idle", "running", self.isRunning)
        self:addTransition("running", "stopping", self.isStopped)
        self:addTransitionOnAnimationEnd("stopping", "idle")
        self:addInstantTransition("_start", "idle")
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