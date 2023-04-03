TreePair = Class {}

-- Increasing this variable will make the game easier (need to adjust the gap texture accordingly)
local GAP_HEIGHT = 40
local GAP_IMAGE = love.graphics.newImage('Assets/Images/TreeGap.png')

function TreePair:init(y)
    self.x = VIRTUAL_WIDTH + 30
    self.y = y
    self.trees = {
        ['upper'] = Tree('top', self.y),
        ['lower'] = Tree('bottom', self.y + TREE_HEIGHT + GAP_HEIGHT)
    }
    self.remove = false
    self.scored = false
end

function TreePair:update(dt)
    if self.x > -TREE_WIDTH then
        self.x = self.x - TREE_SCROLL_SPEED * dt
        self.trees['upper'].x = self.x
        self.trees['lower'].x = self.x
    else
        self.remove = true -- Make the pair ready for despawning if it passes the whole screen
    end
end

function TreePair:render()
    for k, tree in pairs(self.trees) do
        tree:render()
    end
    love.graphics.draw(GAP_IMAGE, self.x + 1, self.y + TREE_HEIGHT)
end
