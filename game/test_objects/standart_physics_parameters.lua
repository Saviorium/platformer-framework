local standartPhysicsProcessorParams = {
    layers = {
        player = {
            gravityEnabled = true,
            collidedLayers = {'terrain'},
            actionLayers = {},
        },
        terrain = {
            gravityEnabled = false,
            collidedLayers = {},
            actionLayers = {},
        }
    },
    objectsTypes = {
        SolidBody = {
            gravity = Vector(0, 0),
            maxVelocity = Vector(0, 0),
            isColliding = false,
        },
        RigidBody = {
            gravity = Vector(0, 0.05),
            maxVelocity = Vector(3, 10),
            isColliding = true,
        }
    }
}

return standartPhysicsProcessorParams 
