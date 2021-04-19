local Class = require "lib.hump.class"
local InputGenerator = require "engine.controls.input_generator"

local AIList = {}

local RandomInputGenerator = Class {
    __includes = InputGenerator,
    init = function(self)
        InputGenerator.init(self)
    end
}
function RandomInputGenerator:getInputSnapshot()
    local rndValue = love.math.random(4)
    local inputs = {
        up = rndValue == 1 and 1 or 0,
        down = rndValue == 2 and 1 or 0,
        left = rndValue == 3 and 1 or 0,
        right = rndValue == 4 and 1 or 0,
    }
    inputs.move = { x = inputs.right - inputs.left, y = inputs.up - inputs.down }
    return inputs
end

function AIList.getFlyingEnemyAI(actor) --, player, targetSystem, andWhatNot )
    return RandomInputGenerator()
end

return AIList