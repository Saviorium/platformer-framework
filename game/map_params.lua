local Player = require "game.test_objects.player.player"
local Box = require "game.test_objects.box"
local Enemy = require "game.test_objects.enemy.enemy"

local mapParams = {
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
        },
        enemy = {
            registerFunction =
            function(object, Map, PhysicsProcessor)
                return Enemy(object.x, object.y)
            end
        }
    }
}

return mapParams
