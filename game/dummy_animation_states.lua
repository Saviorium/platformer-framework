local AnimationState = require "engine.animation_state"

return {
    running = function(animator)
        return AnimationState(
            "running",
            animator,
            nil,
            function(self) self.animator:play("run") end,
            nil 
        )
    end,
    stopping = function(animator)
        return AnimationState(
            "stopping",
            animator,
            nil,
            function(self) self.animator:play("brake") end,
            nil
        )
    end,
    idle = function(animator)
        print(animator)
        return AnimationState(
            "idle",
            animator,
            nil,
            function(self) self.animator:play("idle") end,
            nil
        )
    end,
}