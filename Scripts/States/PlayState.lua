-- The state where the player gets to actually try flying throught trees - Game enters score state when the player loses
PlayState = Class {
    __includes = BaseState
}

function PlayState:init()
    self.bird = Bird()
    self.treePairs = {}
    self.treeSpawnTimer = 0
    self.score = 0
    self.lastY = -TREE_HEIGHT + math.random(80) + 20 --[[ A refference to the y coordinate of the latest treePair created so 
    -- every treePair's y is dependent on the last one to prevent extreme height differences between treePairs ]]
end

function PlayState:update(dt)
    self.treeSpawnTimer = self.treeSpawnTimer + dt
    if self.treeSpawnTimer > 2 then -- Spawns a new treePair every 2 seconds
        local y = math.max(-TREE_HEIGHT + 10,
            math.min(self.lastY + math.random(-30, 30), VIRTUAL_HEIGHT - 90 - TREE_HEIGHT)) --[[ Make a random new height for 
            the spawned treePair based on the last one, and limit it from above and below ]]
        self.lastY = y

        table.insert(self.treePairs, TreePair(y))
        self.treeSpawnTimer = 0
    end

    -- Check if the bird has gone through a tree or not
    for k, treePair in pairs(self.treePairs) do
        if not treePair.scored then
            if treePair.x + TREE_WIDTH < self.bird.x then
                self.score = self.score + 1
                treePair.scored = true
                sounds['score']:play()
            end
        end
        treePair:update(dt)
    end

    -- Despawn the trees past the screen
    for k, treePair in pairs(self.treePairs) do
        if treePair.remove then
            table.remove(self.treePairs, k)
        end
    end

    self.bird:update(dt)

    -- Enter score state if the player touches a tree
    for k, treePair in pairs(self.treePairs) do
        for l, tree in pairs(treePair.trees) do
            if self.bird:collides(tree) then
                gStateMachine:change('score', {
                    score = self.score
                })
                sounds['explosion']:play()
                sounds['hurt']:play()
            end
        end
    end

    -- Enter score state if the player falls below the screen
    if self.bird.y + BIRD_HEIGHT >= VIRTUAL_HEIGHT then
        gStateMachine:change('score', {
            score = self.score
        })
        sounds['explosion']:play()
        sounds['hurt']:play()
    end

    -- Enter score state if the player flies above the screen
    if self.bird.y <= -BIRD_HEIGHT then
        gStateMachine:change('score', {
            score = self.score
        })
        sounds['explosion']:play()
        sounds['hurt']:play()
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
