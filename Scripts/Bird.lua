Bird = Class {}
local GRAVITY = 15
local FLYAMOUNT = 3
local BIRD_IMAGE = love.graphics.newImage('/Assets/Images/Bird.png')
local LEFT_GAP = 4
local RIGHT_BOTTOM_GAP = 1
local TOP_GAP = 3

BIRD_WIDTH = BIRD_IMAGE:getWidth()
BIRD_HEIGHT = BIRD_IMAGE:getHeight()

function Bird:init()
    self.x = VIRTUAL_WIDTH / 2 - (BIRD_WIDTH / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (BIRD_HEIGHT / 2)

    self.dy = 0
end

function Bird:collides(tree)
    if (self.x + LEFT_GAP) <= (tree.x + tree.width) and (self.x + BIRD_WIDTH - RIGHT_BOTTOM_GAP) >= (tree.x) and
        (self.y + TOP_GAP) <= (tree.y + tree.height) and (self.y + BIRD_HEIGHT - RIGHT_BOTTOM_GAP) >= (tree.y) then
        return true
    end
    return false
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt
    if love.keyboard.wasPressed('space') then
        self.dy = -FLYAMOUNT
    end
    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(BIRD_IMAGE, self.x, self.y)
end
