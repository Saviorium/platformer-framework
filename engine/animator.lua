local Class = require "lib.hump.class"
local Peachy = require "lib.peachy.peachy"
local AnimationState = require "engine.animation_state"

local Animator = Class {
    init = function(self, animation)
        self.animation = animation
        self.states = {}
        self.transitions = {} -- self.transitions[from][to] = condition
        self.state = nil
        self.variables = {}
        self._isLooped = false
        self.animation:onLoop(function() self._isLooped = true end)
    end
}

function Animator:play(tag)
    self.animation:setTag(tag)
    self.animation:play()
end

function Animator:addState(state)
    self.states[state.name] = state
end

function Animator:createSimpleTagState(stateName, tagName)
    if not tagName then
        tagName = stateName
    end
    return AnimationState(
        stateName,
        self,
        nil,
        function(self) self.animator:play(tagName) end,
        nil
    )
end

function Animator:addSimpleTagState(stateName, tagName)
    local state = self:createSimpleTagState(stateName, tagName)
    self:addState(state)
    return state
end

function Animator:addInstantTransition(from, to)
    self:addTransition(from, to, function() return true end)
end

function Animator:addTransitionOnAnimationEnd(from, to, condition)
    if not condition then
        self:addTransition(from, to, self.isLooped)
    else
        self:addTransition(from, to, function() return condition and self:isLooped() end)
    end
end

-- from - string or { string, string, ... }
-- special states:
-- *      - any state
-- _start - first transition on init
-- to - string
-- condition - function, returns bool
function Animator:addTransition(from, to, condition)
    if type(from) == "string" or type(from) == "number" then
        from = {from}
    end
    for _, fromState in ipairs(from) do
        if not self.transitions[fromState] then
            self.transitions[fromState] = {}
        end
        self.transitions[fromState][to] = condition
    end
end


function Animator:isLooped()
    return self._isLooped
end


function Animator:setVariable(key, value)
    self.variables[key] = value
end

function Animator:getVariable(key)
    return self.variables[key]
end


function Animator:draw(x, y, rot, sx, sy, ox, oy)
    self.animation:draw(x, y, rot, sx, sy, ox, oy)
end

function Animator:update(dt)
    local currentState = self.state
    self.animation:update(dt)
    if currentState and self.states[currentState] and self.states[currentState].update then
        self.states[currentState]:update(dt)
    end

    local transitionTo
    if currentState then
        transitionTo = self:_checkTransitions(self.transitions["*"])
        transitionTo = self:_checkTransitions(self.transitions[currentState]) -- FIXME: this is a bug for sure
    else
        transitionTo = self:_checkTransitions(self.transitions["_start"])
    end
    if transitionTo then
        self:switchToState(transitionTo)
    end
end

function Animator:_checkTransitions(from)
    if not from then
        return nil
    end

    for toState, condition in pairs(from) do
        if condition and condition(self) then
            return toState
        end
    end
    return nil
end

function Animator:switchToState(state)
    if self.states[self.state] and self.states[self.state].onExit then
        self.states[self.state]:onExit()
    end
    self.state = state
    self._isLooped = false
    if Debug and Debug.PrintAnimationEvents then
        print("Switched to animation state: " .. state)
    end
    if self.states[self.state] and self.states[self.state].onEnter then
        self.states[self.state]:onEnter()
    end
end

return Animator
