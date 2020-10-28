local Map = {
    map = nil,
    layers = {},
    objectTypes = {},
    ground = {},
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

function Map:addLayer(layerName, newLayer)
    self.layers[layerName] = newLayer 
end

function Map:registerLayer(name, priorityToDraw, objectTypes)
    local newLayer = {   
        priorityToDraw = priority and priority or 5,
        objectTypes = objectTypes,
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

function Map:init(mapFileName, PhysicsProcessor)
    self.map = sti("data/maps/" .. mapFileName .. ".lua")
    for name, obj in pairs(self.layers) do
        -- print(name)
        if self.map.layers[name] then
            self.ground[name] = self.map.layers[name]
            for index, objectTypeName in pairs(obj.objectTypes) do
                if self.ground[name].objects then
                    for _, mapObject in pairs(self.ground[name].objects) do  
                        if mapObject.type == objectTypeName then
                            self.objectTypes[objectTypeName].registerFunction(mapObject, self, PhysicsProcessor)
                        end
                    end
                end
            end
            self.ground[name].priorityToDraw = obj.priorityToDraw
        end
    end
    -- sort = function(a, b) 
    --     print(a.priorityToDraw, b.priorityToDraw) 
    --     return a.priorityToDraw < b.priorityToDraw 
    -- end
    -- table.sort (self.ground , sort )

    -- for name, obj in pairs(self.ground) do
    --     print(name)
    -- end
end

function Map:update(dt)
    self.map:update(dt)
end

function Map:draw()
    for ind, layer in pairs(self.ground) do
        self.map:drawLayer(layer)
    end
end

return function(params) return Map:loadParameters(params) end