ScoreState = Class {
    __includes = BaseState
}

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    love.graphics.setFont(titleFont)
    love.graphics.printf('You lost!', 0, 60, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 90, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again', 0, 110, VIRTUAL_WIDTH, 'center')
end
