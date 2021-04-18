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
            maxSpeed = 0,
            isColliding = false,
        },
        RigidBody = {
            gravity = Vector(0, 0.05),
            maxSpeed = 10,
            isColliding = true,
        }
    }
}

return standartPhysicsProcessorParams