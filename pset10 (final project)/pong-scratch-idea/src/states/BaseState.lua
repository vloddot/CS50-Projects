BaseState = Class{}

function BaseState:init() end
function BaseState:enter(params)
    self.player1 = Paddle(10, 30, true)
    self.player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, false)
    -- self.ball = Ball()
end
function BaseState:exit() end
function BaseState:update(dt)
    self.player1:update(dt)
    self.player2:update(dt)
    -- self.ball:update(dt)
end
function BaseState:render()
    self.player1:render()
    self.player2:render()
    -- self.ball:draw()
end