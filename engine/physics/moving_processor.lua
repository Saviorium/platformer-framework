local Vector = require "lib.hump.vector"

local MovingProcessor = {
    function addAccelerationToObjectAndCalculateFriction(object, acceleration)
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

return MovingProcessor