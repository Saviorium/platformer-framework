local standartControlsParams = {
    controls = {
        space = {'up', },
        s = {'down', },
        a = {'left', },
        d = {'right', },
    },
    flags = {
        up = {state = false,
              action =
              function(object)
                  object.PhysicsProcessor.addAccelerationToObjectAndCalculateFriction( Vector(0, -1))
                  object.isGrounded = false
              end
        },
        down = {state = false,
            action =
            function(object)
                object.PhysicsProcessor.addAccelerationToObjectAndCalculateFriction( Vector(0, 1))
                object.isGrounded = false
            end
        },
        left = {state = false,
            action =
            function(object)
                object.PhysicsProcessor.addAccelerationToObjectAndCalculateFriction( Vector(-1, 0))
            end
        },
        right = {state = false,
            action =
            function(object)
                object.PhysicsProcessor.addAccelerationToObjectAndCalculateFriction( Vector(1, 0))
            end
        },
    }
}

return standartControlsParams