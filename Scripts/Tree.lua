Tree = Class {}

TREE_WIDTH = 32
TREE_HEIGHT = 288
TREE_SCROLL_SPEED = 60

local TREE_IMAGE = love.graphics.newImage('Assets/Images/Tree.png')

function Tree:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = TREE_IMAGE:getWidth()
    self.height = TREE_HEIGHT

    self.orientation = orientation
end

function Tree:render()
    love.graphics.draw(TREE_IMAGE, self.x, (self.orientation == 'top' and self.y + TREE_HEIGHT or self.y), 0, 1,
        self.orientation == 'top' and -1 or 1)
end
