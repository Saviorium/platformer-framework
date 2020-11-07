local Class = require "lib.hump.class"
local InputGenerator = require "engine.controls.input_generator"

local UserInputManager = Class {
    _includes = InputGenerator,
    init = function(self, keyConfig)
        InputGenerator.init(self)
        self.keyConfig = keyConfig
        self.inputSnapshot = self:resetInputs({})
    end
}

function UserInputManager:resetInputs(snapshot)
    -- do that inplace
    for command, _ in pairs(snapshot) do
        snapshot[command] = false
    end
    return snapshot
end

function UserInputManager:update(dt)
    self:resetInputs(self.inputSnapshot)
    self:readKeyboardInputs(self.inputSnapshot)
    self:readGamepadInputs(self.inputSnapshot)
    if Debug and Debug.PrintUserInputs == 1 then
        vardump(inputs)
    end
end

function UserInputManager:readKeyboardInputs(snapshot)
    for command, keys in pairs(self.keyConfig) do
        for _, key in ipairs(keys) do
            snapshot[command] = snapshot[command] or love.keyboard.isDown(key)
        end
    end
    return snapshot
end

function UserInputManager:readGamepadInputs(snapshot)
    -- TODO
    return snapshot
end

function UserInputManager:getInputSnapshot()
    return self.inputSnapshot
end

return UserInputManager
