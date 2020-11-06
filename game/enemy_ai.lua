local Class = require "lib.hump.class"
local InputGenerator = require "engine.controls.input_generator"

local AIList = {}

local RandomInputGenerator = Class {
    _includes = InputGenerator,
    init = function(self)
        InputGenerator.init(self)
    end
}
function RandomInputGenerator:getInputSnapshot()
    local rndValue = love.math.random(4)
    local inputs = {
        up = rndValue == 1,
        down = rndValue == 2,
        left = rndValue == 3,
        right = rndValue == 4
    }
    return inputs
end

function AIList.getFlyingEnemyAI(actor) --, player, targetSystem, andWhatNot )
    return RandomInputGenerator()
end

return AIList