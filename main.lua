push = require 'Libraries/push'
Class = require 'Libraries/class'
require 'Scripts/Bird'
require 'Scripts/Tree'
require 'Scripts/TreePair'
require 'Scripts/StateMachine'
require 'Scripts/States/BaseState'
require 'Scripts.States.TitleScreenState'
require 'Scripts.States.PlayState'
require 'Scripts.States.ScoreState'
require 'Scripts.States.CountdownState'

WINDOW_WIDTH = 1408
WINDOW_HEIGHT = 792

VIRTUAL_WIDTH = 352
VIRTUAL_HEIGHT = 198

local background = love.graphics.newImage('Assets/Images/Background.png')
local ground = love.graphics.newImage('Assets/Images/Ground.png')

local backgroundScroll = 0
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 640
local GROUND_LOOPING_POINT = 24

local scrolling = true

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Fifty bird')

    mediumFont = love.graphics.newFont('Assets/Fonts/font.ttf', 8)
    titleFont = love.graphics.newFont('Assets/Fonts/font.ttf', 16)
    largeFont = love.graphics.newFont('Assets/Fonts/font.ttf', 32)
    love.graphics.setFont(titleFont)

    sounds = {
        ['jump'] = love.audio.newSource('Assets/Audio/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('Assets/Audio/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('Assets/Audio/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('Assets/Audio/score.wav', 'static'),
        ['countdown'] = love.audio.newSource('Assets/Audio/countdown.wav', 'static'),
        ['start'] = love.audio.newSource('Assets/Audio/start.wav', 'static'),
        ['ambient'] = love.audio.newSource('Assets/Audio/forestAmbient.mp3', 'static')
    }

    sounds['ambient']:setLooping(true)
    sounds['ambient']:play()

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['title'] = function()
            return TitleScreenState()
        end,
        ['play'] = function()
            return PlayState()
        end,
        ['score'] = function()
            return ScoreState()
        end,
        ['countdown'] = function()
            return CountdownState()
        end
    }
    gStateMachine:change('title')

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push.resize(w, h)
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, -2)

    gStateMachine:render()

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end
