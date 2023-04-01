CountdownState = Class {
    __includes = BaseState
}

COUNTDOWN_TIME = 1

function CountdownState:init()
    self.count = 3
    self.timer = 0
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
