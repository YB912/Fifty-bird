PlayState = Class {
    __includes = BaseState
}

function PlayState:init()
    self.bird = Bird()
    self.treePairs = {}
    self.treeSpawnTimer = 0
    self.score = 0
    self.lastY = -TREE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    self.treeSpawnTimer = self.treeSpawnTimer + dt
    if self.treeSpawnTimer > 2 then
        local y = math.max(-TREE_HEIGHT + 10,
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - TREE_HEIGHT))
        self.lastY = y

        table.insert(self.treePairs, TreePair(y))
        self.treeSpawnTimer = 0
    end

    for k, treePair in pairs(self.treePairs) do
        if not treePair.scored then
            if treePair.x + TREE_WIDTH < self.bird.x then
                self.score = self.score + 1
                treePair.scored = true
            end
        end
        treePair:update(dt)
    end

    for k, treePair in pairs(self.treePairs) do
        if treePair.remove then
            table.remove(self.treePairs, k)
        end
    end

    self.bird:update(dt)

    for k, treePair in pairs(self.treePairs) do
        for l, tree in pairs(treePair.trees) do
            if self.bird:collides(tree) then
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    if self.bird.y + BIRD_HEIGHT >= VIRTUAL_HEIGHT - 16 then
        gStateMachine:change('score', {
            score = self.score
        })
    end
end

function PlayState:render()
    for k, treePair in pairs(self.treePairs) do
        treePair:render()
    end
    love.graphics.setFont(mediumFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    self.bird:render()
end
