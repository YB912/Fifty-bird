-- An object for managing the game states
StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {}
    -- Default state
	self.current = self.empty
end

function StateMachine:change(stateName, enteringParams)
    assert(self.states[stateName]) -- Make sure that the state with given name exists
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(enteringParams)
end

-- Update and render whatever the current state is
function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end