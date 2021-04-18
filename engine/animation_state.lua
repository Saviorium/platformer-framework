local Class = require "lib.hump.class"
local Peachy = require "lib.peachy.peachy"

local AnimationState = Class {
    init = function(self, name, animator, updateFn, onEnter, onExit)
        self.name = name
        self.animator = animator
        self.update = updateFn
        self.onEnter = onEnter
        self.onExit = onExit
    end
}

return AnimationState
