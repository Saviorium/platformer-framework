require "conf"
require "engine.utils"
Class = require "lib.hump.class"
Vector = require "lib.hump.vector"

Debug = require "engine.debug"
serpent = require "lib.debug.serpent"

StateManager = require "lib.hump.gamestate"
AssetManager = require "engine.asset_manager"

local MusicData = require "game.music_data"
MusicPlayer = require "engine.music_player" (MusicData)

local SoundData = require "game.sound_data"
SoundManager = require "engine.sound_manager" (SoundData)

-- StandardMovingProcessor = require "engine.physics.moving_processor"
standartPhysicsProcessorParams = require "game.test_objects.standart_physics_parameters"
standartPhysicsProcessor = require "engine.physics_processor" (standartPhysicsProcessorParams)

Player = require "game.test_objects.player"
Box = require "game.test_objects.box"
standardMapParams = require "engine.standard_map_params"
Map = require "engine.map" (standardMapParams)

sti     = require "lib/sti"

states = {
    game = require "game.states.game"
}

function love.load()
    AssetManager:load("data")
    StateManager.switch(states.game)
end

function love.draw()
    StateManager.draw()
end

function love.update(dt)
    MusicPlayer:update(dt)
    StateManager.update(dt)
end

function love.mousepressed(x, y)
    if StateManager.current().mousepressed then
        StateManager.current():mousepressed(x, y)
    end
end

function love.mousereleased(x, y)
    if StateManager.current().mousereleased then
        StateManager.current():mousereleased(x, y)
    end
end

function love.keypressed(key)
    if StateManager.current().keypressed then
        StateManager.current():keypressed(key)
    end
end
