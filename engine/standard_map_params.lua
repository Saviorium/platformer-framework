local standardMapParams = {
    layers = {
        solid = {  
            priorityToDraw = 1,
        },
        objects = {  
            priorityToDraw = 2,
        },
        background = {
            priorityToDraw = 4,
        },
        front_layer = {
            priorityToDraw = 3,
        }
    },
    objectTypes = {
        box = {   
            registerFunction =
            function(object, Map, PhysicsProcessor)
                return Box(object.x, object.y, object.width, object.height, PhysicsProcessor)
            end 
        },
        player = {   
            registerFunction = 
            function(object, Map, PhysicsProcessor)
                return Player(object.x, object.y, PhysicsProcessor)
            end
        }
    }
}

return standardMapParams 