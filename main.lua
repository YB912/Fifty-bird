push = require 'Libraries/push'
Class = require 'Libraries/class'
require 'Scripts/Bird'
require 'Scripts/Tree'
require 'Scripts/TreePair'
require 'Scripts/StateMachine'
require 'Scripts/States/BaseState'
require 'Scripts/States/TitleScreenState'
require 'Scripts/States/PlayState'
require 'Scripts/States/ScoreState'
require 'Scripts/States/CountdownState'

WINDOW_WIDTH = 1408
WINDOW_HEIGHT = 792

VIRTUAL_WIDTH = 352
VIRTUAL_HEIGHT = 198

local background0 = love.graphics.newImage('Assets/Images/Background0.png')
local background1 = love.graphics.newImage('Assets/Images/Background1.png')
local background2 = love.graphics.newImage('Assets/Images/Background2.png')
local background3 = love.graphics.newImage('Assets/Images/Background3.png')
local foreground = love.graphics.newImage('Assets/Images/Foreground.png')

-- Scroll variables which serve as -x of the parallax layers' images
local background0Scroll = 0
local background1Scroll = 0
local background2Scroll = 0
local background3Scroll = 0
local foregroundScroll = 0

-- Different speed for each parallax layer
local BACKGROUND0_SCROLL_SPEED = 5
local BACKGROUND1_SCROLL_SPEED = 15
local BACKGROUND2_SCROLL_SPEED = 30
local BACKGROUND3_SCROLL_SPEED = 45
local FOREGROUND_SCROLL_SPEED = 80

-- The limit which each scroll variable will reach before looping 
local BACKGROUND_LOOPING_POINT = 640
-- Higher looping point for the foreground to make its appearance less frequent
local FOREGROUND_LOOPING_POINT = 2560

function love.load()
    -- Nearest-neighbor filtering to prevent blurred textures
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
        resizable = false
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

    -- Custom added table to love.keyboard to keep track of the keys pressed at the current frame
    love.keyboard.keysPressed = {}
end

-- Function to check if a certain key was pressed or not
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
    background0Scroll = (background0Scroll + BACKGROUND0_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    background1Scroll = (background1Scroll + BACKGROUND1_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    background2Scroll = (background2Scroll + BACKGROUND2_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    background3Scroll = (background3Scroll + BACKGROUND3_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    foregroundScroll = (foregroundScroll + FOREGROUND_SCROLL_SPEED * dt) % FOREGROUND_LOOPING_POINT

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    
    -- Render the parallax layers in the correct order
    love.graphics.draw(background0, math.ceil(-background0Scroll), 0)
    love.graphics.draw(background1, math.ceil(-background1Scroll), 0)
    love.graphics.draw(background2, math.ceil(-background2Scroll), 0)
    love.graphics.draw(background3, math.ceil(-background3Scroll), 0)

    gStateMachine:render()

    love.graphics.draw(foreground, math.ceil(-foregroundScroll) + 100, 0)
    push:finish()
    
end
