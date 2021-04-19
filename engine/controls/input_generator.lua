local Class = require "lib.hump.class"

local InputGenerator = Class {
    init = function(self)
        self.inputSnapshot = {
            -- up   = 1
            -- jump = 1
            -- move = { x = 0.5, y = -1 }
            -- etc.
        }
    end
}

function InputGenerator:update(dt)
    -- update inputSnapshot here
    -- self.inputSnapshot = {}
end

function InputGenerator:getInputSnapshot()
    return self.inputSnapshot
end

return InputGenerator
