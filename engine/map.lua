local sti = require "lib/sti"

local Map = Class {
    init = function(self, params, mapFileName, arx)

        self.map = nil
        self.layers = {}
        self.objectTypes = {}
        self.ground = {}
        self.objects = {}

        self:loadParameters(params)
        self:load(mapFileName, arx)
    end
}

function Map:loadParameters(params)
    if params.layers then
        self.layers = params.layers
    end
    if params.objectTypes then
        self.objectTypes = params.objectTypes
    end
    if params.PhysicsProcessor then
        self.PhysicsProcessor = params.PhysicsProcessor
    end
    return self
end

function Map:getObject(name)
    return self.objects[name]
end

function Map:addLayer(layerName, newLayer)
    self.layers[layerName] = newLayer 
end

function Map:registerLayer(name, priorityToDraw, objectTypes)
    local newLayer = {   
        priorityToDraw = priority and priority or 5,
    }
    self:addLayer(name, newLayer)
end

function Map:addType(typeName, newType)
    self.objectTypes[typeName] = newType 
end

function Map:registerType(name, registerFunction)
    local newType = {   
        registerFunction = registerFunction,
    }
    self:addType(name, newType)
end

function Map:load(mapFileName, arx)
    self.map = sti("data/maps/" .. mapFileName .. ".lua")
    for name, obj in pairs(self.layers) do
        if self.map.layers[name] then
            self.ground[name] = self.map.layers[name]
            if self.ground[name].objects then
                for _, mapObject in pairs(self.ground[name].objects) do
                    if mapObject.name ~= nil and mapObject.name ~= '' then
                        if self.objects[mapObject.name] then
                            error("Error loading map: conficting object name") -- todo: register as new name?
                        end
                        self.objects[mapObject.name] = self.objectTypes[mapObject.type].registerFunction(mapObject, self, arx)
                    else
                        table.insert(self.objects, self.objectTypes[mapObject.type].registerFunction(mapObject, self, arx))
                    end
                end
            end
            self.ground[name].priorityToDraw = obj.priorityToDraw
        end
    end
end

function Map:update(dt)
    self.map:update(dt)
    for _, obj in pairs(self.objects) do
        obj:update(dt)
    end
end

function Map:draw()
    for ind, layer in pairs(self.ground) do
        self.map:drawLayer(layer)
    end
    for _, obj in pairs(self.objects) do
        obj:draw()
    end
end

return Map