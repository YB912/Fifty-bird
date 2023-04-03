-- A state where the game counts down from 3 before proceeding to the play state
CountdownState = Class {
    __includes = BaseState
}

COUNTDOWN_TIME = 1 -- Length of each count in seconds

function CountdownState:init()
    self.count = 3 -- The number to begin counting down from
    self.timer = 0 -- A constantly increasing variable which triggers a count every time it reaches the COUNTDOWN_TIME
end

function CountdownState:enter()
    sounds['countdown']:play()
end

function CountdownState:update(dt)
    self.timer = self.timer + dt
    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1
        if self.count == 0 then
            gStateMachine:change('play')
            sounds['start']:play()
            return
        end
        sounds['countdown']:play()
    end
end

function CountdownState:render()
    love.graphics.setFont(largeFont)
    love.graphics.printf(tostring(self.count), 0, 70, VIRTUAL_WIDTH, 'center')
end
