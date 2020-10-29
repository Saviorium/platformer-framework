local Bullet = require "game.bullet"
local AnimatedDummy = require "game.animated_dummy"
local HC = require "lib.hardoncollider"

local game = {}

function game:enter()
    self.hc = HC.new()

    self.sprite = AssetManager:getAnimation("player")
    self.sprite:setTag("idle")
    self.sprite:play()
    self.bg = AssetManager:getImage("city_background2")
    MusicPlayer:registerRhythmCallback("bar", function() table.insert(self.bullets, Bullet(40 * 1, 50, 0, 200, 10, {1,0,0})) end)
    MusicPlayer:registerRhythmCallback("onBeat", function() table.insert(self.bullets, Bullet(40 * 2, 50, 0, 200, 5, {0,0,1})) end)
    MusicPlayer:registerRhythmCallback("offBeat", function() table.insert(self.bullets, Bullet(40 * 3, 50, 0, 200, 5, {0,1,0})) end)
    MusicPlayer:registerRhythmCallback("beat", function() table.insert(self.bullets, Bullet(40 * 4, 50, 0, 200, 2, {1,1,0})) end)
    MusicPlayer:registerRhythmCallback("syncopated", function() table.insert(self.bullets, Bullet(40 * 5, 50, 0, 200, 2, {1,0.2,0})) end)
    MusicPlayer:registerRhythmCallback({3}, function() table.insert(self.bullets, Bullet(40 * 1, 50, 0, 200, 10, {1,0,1})) end)
    -- MusicPlayer:play("level1")
    self.soundA = AssetManager:getSound("jump")
    self.soundA:setVolume(0.1)
    self.soundB = AssetManager:getSound("jump")
    self.soundB:setVolume(0.9)

    self.animatedDummy = AnimatedDummy(150, 100)

    self.bullets = {}

    self.PhysicsProcessor = standartPhysicsProcessor
    self.Map = Map
    self.Map:init('test_level1', self.PhysicsProcessor)
    self.objects = {}
    -- local start_x, start_y = 100, 100
    -- local step = 100
    -- table.insert(self.objects, Box(start_x, start_y, 100, 10, self.PhysicsProcessor))
    -- table.insert(self.objects, Box(start_x+step, start_y+step, 100, 10, self.PhysicsProcessor))
    -- table.insert(self.objects, Box(start_x+2*step, start_y+2*step, 100, 10, self.PhysicsProcessor))
    -- table.insert(self.objects, Player(start_x+2*step, start_y+1.5*step, self.PhysicsProcessor))
end

function game:mousepressed(x, y)
end

function game:mousereleased(x, y)
end

function game:keypressed(key)
    if key == "z" then
        self.soundA:play()
    end
    if key == "x" then
        self.soundB:play()
    end
    if key == "t" then
        MusicPlayer:play("level1", "out-instant")
    end
    if key == "y" then
        MusicPlayer:play("level2", "out-in")
    end
    if key == "g" then
        SoundManager:play("smallExplosion")
    end
    if key == "1" and key == "2" or key == "3" or key == "4" then
        self.Map:init('test_level'..key, self.PhysicsProcessor)
    end
end

function game:draw()
    love.graphics.draw(self.bg)
    self.Map:draw()
    self.sprite:draw(10, 10)
    self.animatedDummy:draw()

    for _, bullet in ipairs(self.bullets) do
        bullet:draw()
    end
    for _, object in ipairs(self.PhysicsProcessor.objects) do
        object:draw()
    end

    love.graphics.setColor(0, 0, 1)
    local shapes = self.PhysicsProcessor.HC:hash():shapes()
    for _, shape in pairs(shapes) do
        shape:draw()
    end
    love.graphics.setColor(1, 1, 1)
    
end

function game:update(dt)
    if love.keyboard.isDown("right") then
        self.animatedDummy:move()
    end
    for _, bullet in ipairs(self.bullets) do
        bullet:update(dt)
    end
    self.animatedDummy:update(dt)
    for _, object in ipairs(self.objects) do
        object:update(dt)
    end
    self.PhysicsProcessor:update(dt)
    love.graphics.setColor({1,1,1})
    self.sprite:update(dt)
    self.Map:update(dt)
end

return game