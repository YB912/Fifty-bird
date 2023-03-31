push = require 'Libraries/push'
Class = require 'Libraries/class'
require 'Scripts/Bird'
require 'Scripts/Tree'
require 'Scripts/TreePair'

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

local bird = Bird()

local treePairs = {}

local treeSpawnTimer = 0

local lastY = -TREE_HEIGHT + math.random(80) + 20

local scrolling = true

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Fifty bird')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

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
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

        treeSpawnTimer = treeSpawnTimer + dt

        if treeSpawnTimer > 2 then
            local y = math.max(-TREE_HEIGHT + 10,
                math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - TREE_HEIGHT))
            lastY = y

            table.insert(treePairs, TreePair(y))
            treeSpawnTimer = 0
        end

        bird:update(dt)

        for k, treePair in pairs(treePairs) do
            treePair:update(dt)

            for l, tree in pairs(treePair.trees) do
                if bird:collides(tree) then
                    scrolling = false
                end
            end

            if treePair.x < -TREE_WIDTH then
                treePair.remove = true
            end
        end

        for k, treePair in pairs(treePairs) do
            if treePair.remove then
                table.remove(treePairs, k)
            end
        end

    end

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, -2)

    for k, treePair in pairs(treePairs) do
        treePair:render()
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()

    push:finish()
end
