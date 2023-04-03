-- A superclass with empty abstract methods for all the game states to polymorphically implement them as needed
BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end