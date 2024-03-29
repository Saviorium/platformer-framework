local Player = require "game.test_objects.player.player"
local Box = require "game.test_objects.box"
local Bullet = require "game.test_objects.bullet"
local AnimatedDummy = require "game.test_objects.animated_dummy.animated_dummy"

local NineSliceSprite = require "engine.ui.nine_slice_sprite"

local HC = require "lib.hardoncollider"

local Enemy = require "game.test_objects.enemy.enemy"

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
    self.objects = {}
    local start_x, start_y = 100, 100
    local step = 50
    table.insert(self.objects, Box(start_x, start_y, 100, 10, self.PhysicsProcessor))
    table.insert(self.objects, Box(start_x+step, start_y+step, 100, 10, self.PhysicsProcessor))
    table.insert(self.objects, Box(start_x+2*step, start_y+2*step, 100, 10, self.PhysicsProcessor))
    table.insert(self.objects, Player(start_x+2*step, start_y+1.5*step, self.PhysicsProcessor))
    table.insert(self.objects, Enemy(start_x+5*step, start_y+1.5*step))

    local nineSliceImage = AssetManager:getImage("9-slice")
    self.nineSprite = NineSliceSprite(nineSliceImage, Vector(8, 8)):setSize(100, 100)
    self.nineSpriteSize = 100
    self.nineSpriteDt = 3

    self.buttonSprite = NineSliceSprite(AssetManager:getImage("button"), 3):setSize(50, 20)
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
    if key == "c" then
        self.objects[5]:takeControl(UserInputManager)
    end
end

function game:draw()
    love.graphics.draw(self.bg)
    self.nineSprite:draw(130, 250)
    self.buttonSprite:draw()
    self.sprite:draw(10, 10)
    self.animatedDummy:draw()

    for _, bullet in ipairs(self.bullets) do
        bullet:draw()
    end
    for _, object in ipairs(self.objects) do
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

    if self.nineSpriteSize > 300 or self.nineSpriteSize < 50 then
        self.nineSpriteDt = -self.nineSpriteDt
    end
    self.nineSpriteSize = self.nineSpriteSize + self.nineSpriteDt
    self.nineSprite:setSize(self.nineSpriteSize, self.nineSpriteSize)
end

return game