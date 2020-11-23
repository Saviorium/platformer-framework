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
        priorityToDraw = priorityToDraw and priorityToDraw or 5,
    }
    self:addLayer(name, newLayer)
end

function Map:addObjectType(objectTypeName, newObjectType)
    self.objectTypes[objectTypeName] = newObjectType 
end

function Map:registerType(name, registerFunction)
    local newType = {   
        registerFunction = registerFunction,
    }
    self:addObjectType(name, newType)
end

function Map:init(mapFileName, PhysicsProcessor)
    self.map = sti("data/maps/" .. mapFileName .. ".lua")
    for name, obj in pairs(self.layers) do
        if self.map.layers[name] then
            self.ground[name] = self.map.layers[name]
            if self.ground[name].objects then
                for _, mapObject in pairs(self.ground[name].objects) do  
                    self.objectTypes[mapObject.type].registerFunction(mapObject, self, PhysicsProcessor)
                end
            end
            self.ground[name].priorityToDraw = obj.priorityToDraw
        end
    end
    -- // TO-DO // -- Функция сортировки(хоть пузырьком, хоть фаст сортом главное сделать сортировку по priorityToDraw)
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