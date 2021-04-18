require "conf"
require "engine.utils.utils"
Vector = require "lib.hump.vector"

Debug = require "engine.utils.debug"
serpent = require "lib.debug.serpent"

StateManager = require "lib.hump.gamestate"

AssetManager = require "engine.utils.asset_manager"

MusicData = require "game.music_data"
MusicPlayer = require "engine.sound.music_player" (MusicData)

SoundData = require "game.sound_data"
SoundManager = require "engine.sound.sound_manager" (SoundData)

-- StandartMovingProcessor = require "engine.physics.moving_processor"
standartPhysicsProcessorParams = require "engine.physics.standart_physics_parameters"
standartPhysicsProcessor = require "engine.physics.physics_processor" (standartPhysicsProcessorParams)

Player = require "game.test_objects.player"
Box = require "game.test_objects.box"



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
