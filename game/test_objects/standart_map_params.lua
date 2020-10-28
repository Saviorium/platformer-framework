local standartMapParams = {
    layers = {
        solid = {  
            priorityToDraw = 1,
            objectTypes = {'terrain'},
        },
        objects = {  
            priorityToDraw = 2,
            objectTypes = {'box', 'player'},
        },
        background = {
            priorityToDraw = 4,
            objectTypes = {},
        },
        front_layer = {
            priorityToDraw = 3,
            objectTypes = {},
        }
    },
    objectTypes = {
        box = {   
            registerFunction =
            function(object, Map, PhysicsProcessor)
                Box(object.x, object.y, object.width, object.height, PhysicsProcessor)
            end 
        },
        player = {   
            registerFunction = 
            function(object, Map, PhysicsProcessor)
                Player(object.x, object.y, PhysicsProcessor)
            end
        }
    }
}

return standartMapParams 