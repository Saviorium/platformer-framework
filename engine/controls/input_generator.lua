local Class = require "lib.hump.class"

local InputGenerator = Class {
    init = function(self)
        self.inputSnapshot = {
            -- command  = true
            -- command2 = 1
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
