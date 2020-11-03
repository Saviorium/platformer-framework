local ControlsManager = {
    controls = {},
    flags = {}
}

function ControlsManager:loadParameters(params)
    if params.controls then
        self.controls = params.controls
    end
    if params.flags then
        self.flags = params.flags
    end
    return self
end

function ControlsManager:addControlRule(control, affectedFlags)
    self.controls[control] = affectedFlags
end

function ControlsManager:registerControlRule(control, affectedFlags)
    if self.controls[control] then
        for _, flag in pairs(affectedFlags) do
            if isIn(self.flags, flag) and not isIn(self.controls[control], flag)  then
                table.insert(self.controlRules[name].affectedFlags, flag)
            end
        end
    else
        self:addControlRule(control, affectedFlags)
    end
end

function ControlsManager:registerFlag(flag, action)
    self.flags[flag] = {
        state = false,
        action = action
    }
end

function ControlsManager:keyPressed(key)
    for ind, flag in pairs(self.controls[key]) do
        self.flags[flag] = true
    end
end

function ControlsManager:checkFlagState(flagName)
    return self.flags[flagName].state
end

function ControlsManager:tryToMakeAction(flagName, object)
    if self.flags[flagName].state then
        self.flags[flagName].action(object)
    end
end

function ControlsManager:makeAllActions(object)
    for ind, flag in pairs(self.flags) do
        if flag.state then
            flag.action(object)
        end
    end
end

function ControlsManager:resetFlags()
    for ind, flag in pairs(self.flags) do
        self.flags[ind] = false
    end
end

return function(params) return ControlsManager:loadParameters(params) end