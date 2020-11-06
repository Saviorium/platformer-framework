config = {
    keyBindings = {
        up = {"w", "up"},
        down = {"s", "down"},
        left = {"a", "left"},
        right = {"d", "right"},
        use = {"e", "x"},
        attack = {"space", "z"}
    }
}

function love.conf(t)
    t.window.title = "platformer-example"
end