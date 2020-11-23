local Vector = require "lib.hump.vector"
local HC = require "lib.hardoncollider"
local PhysicsObject = require "engine.physics.physics_object"

function move(object, moveVector )
    object.position = object.position + moveVector
    object.collider:move(moveVector)
end

local DefaultPlatformingCollisionResolver = {
        resolveCollisionsForObject = function (object)
            if math.abs(object.deltaVector.x) > object.maxGroundNormal then
                move(object, Vector(object.deltaVector.x/2,0))
            end

            if math.abs(object.deltaVector.y) > object.maxGroundNormal then
                object.velocity.y = (object.velocity.y < 0 or object.deltaVector.y < 0) and 0 or object.velocity.y
                move(object, Vector(0,object.deltaVector.y/2))
                object.isGrounded = object.deltaVector.y < -object.minGroundNormal
            end
            
            if math.abs(object.deltaVector.y) < object.minGroundNormal and object.isGrounded then
                object.isGrounded = false
            end  
        end
    }

local DefaultPlatformingMovingProcessor = {
        addAccelerationToObjectAndCalculateFriction = function (object, acceleration)
            -- Блок накидывания скорости объекту
            if (object.velocity.x + acceleration.x) <= object.maxSpeed then
                object.velocity.x = object.velocity.x + acceleration.x
            else
                object.velocity.x = direction.x * object.maxSpeed
            end
            object.velocity.y = object.velocity.y + acceleration.y

            -- Блок снижения скорости (гравитация и трение о поверхность воздух, вся фигня)
            local slowDownDirection = object.velocity.x >= 0 and -1 or 1
            if -slowDownDirection * (object.velocity.x + slowDownDirection * object.slowDownSpeed ) > 0 then
                object.velocity.x = object.velocity.x + slowDownDirection * object.slowDownSpeed
            else
                object.velocity.x = 0
            end

            if not object.isGrounded and object.velocity.y <= object.maxSpeed  then
                object.velocity = object.velocity + object.gravity
            end
        end
    }
local PhysicsProcessor = {
    HC = HC.new(),
    globalGravity = Vector( 0, 0.05),
    objects = {},
    layers = {},
    objectsTypes = {},
    collisionResolver = DefaultPlatformingCollisionResolver,
    movingProcessor = DefaultPlatformingMovingProcessor,
}

function PhysicsProcessor:loadParameters(params)
    if params.movingProcessor then
        self.movingProcessor = params.movingProcessor
    end
    if params.collisionResolver then
        self.collisionResolver = params.collisionResolver
    end
    if params.layers then
        self.layers = params.layers
    end
    if params.objectsTypes then
        self.objectsTypes = params.objectsTypes
    end
    return self
end

function PhysicsProcessor:addType(typeName, newType)
    self.objectsTypes[typeName] = newType 
end

-- typeName - Naming of type and index in table - string
-- gravity  - Vector of gravity if null - pick standard global gravity
-- maxSpeed - Maximum speed of an object, if 0 then object immovable, if null - take default max speed
-- isColliding - bool = can be pushed by another object?
function PhysicsProcessor:registerObjectType(typeName, gravity, maxSpeed, isColliding)
    local newType = {   
        gravity = gravity and gravity or self.globalGravity,
        maxSpeed = maxSpeed and maxSpeed or 10,
        isColliding = isColliding and isColliding or true,
    }
    self:addType(typeName, newType)
end


function PhysicsProcessor:getAllLayerNames()
    local newCollidedLayers = {}
    for ind, layer in pairs(self.layers) do
        table.insert( newCollidedLayers, layer.name )
    end
    return newCollidedLayers
end

function PhysicsProcessor:addLayer(layerName, newLayer )
    self.layers[layerName] = newLayer 
end

-- layerName - Naming of layer and index in table - string
-- gravity  - bool = are objects in the layer affected by gravity?
function PhysicsProcessor:registerLayer( layerName, gravity )
    local newLayer = {  
                        gravityEnabled = gravity and gravity or true,
                        collidedLayers = {},
                        actionLayers = {},
                     }
    self:addLayer(layerName, newLayer)
end

-- layerName - index in layers table - string
-- collidedLayersNames - table layer names for object to collide with
function PhysicsProcessor:addCollidedLayers(layerName, collidedLayersNames)
    for _, name in pairs(collidedLayersNames) do
        if isIn(self.layers, name) and not isIn( self.layers[layerName].collidedLayers, name) then
            table.insert( self.layers[layerName].collidedLayers, name )
        end
    end
end

-- layerName - index in layers table - string
-- actionLayersNames - table of layer names for object to get action with
function PhysicsProcessor:addActionLayers(layerName, actionLayersNames)
    for _, name in pairs(actionLayersNames) do
        if isIn(self.layers, name) and not isIn( self.layers[layerName].actionLayers, name)then
            table.insert( self.layers[layerName].actionLayers, name )
        end
    end
end

-- object - object which implemented PhysicsObject to register
-- x, y - coords to spawn object and collider
-- layer - layer name - string
-- type of object = string
function PhysicsProcessor:registerObject(object, x, y, layer, type)
    table.insert( self.objects, object )
    object.collider.layer = layer
    PhysicsObject.init( object, x, y, 
                        self.objectsTypes[type].gravity, 
                        self.objectsTypes[type].maxSpeed, 
                        self.objectsTypes[type].isColliding )
end

function PhysicsProcessor:destroyObject(object)
    self.HC:remove(object.collider)
    table.remove(self.objects, getIndex(self.objects, object))
end

function PhysicsProcessor:calculateCollisions()

    for ind, object in pairs(self.objects) do
        local collisions = self.HC:collisions(object.collider)

        for shape, delta in pairs(collisions) do

            local collidedObject
            for ind, physicsObject in pairs(self.objects) do
                collidedObject = physicsObject.collider == shape and physicsObject or collidedObject
            end

            if collidedObject then
                if isIn(self.layers[object.collider.layer].collidedLayers, collidedObject.collider.layer) and object.isColliding then
                    if object.registerCollision then
                        object.registerCollision(object, collidedObject, delta)
                    else
                        object.defaultCollisionReaction(object, delta)
                    end
                end
                if isIn(self.layers[object.collider.layer].actionLayers, collidedObject.collider.layer) then
                    
                    if object.registerAction then
                        object.registerAction(object, collidedObject, delta)
                    end
                end
            end
        end
    end
end


function PhysicsProcessor:update(dt)
    self:calculateCollisions()
    for ind, object in pairs(self.objects) do
        self.movingProcessor.addAccelerationToObjectAndCalculateFriction(object, Vector(0, 0)) 
        self.collisionResolver.resolveCollisionsForObject(object)
        move(object, object.velocity)
        object.deltaVector = Vector( 0, 0)
    end
end

return function(params) return PhysicsProcessor:loadParameters(params) end
