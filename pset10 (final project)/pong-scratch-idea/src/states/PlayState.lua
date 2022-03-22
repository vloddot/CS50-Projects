PlayState = Class{__includes = BaseState}

--[[
    PlayState:enter(params)
    Called whenever the PlayState is entered and is passed a bunch of paramters
    which are used to keep a loop between states without instantiating class data over and over again
    every state change
]]
function PlayState:enter(params)
    self.player1 = params.player1
    self.player2 = params.player2
    self.ball = params.ball
end

--[[
    PlayState:update(dt)
    Called in love.update(dt) each frame
]]
function PlayState:update(dt)

    -- Update player 1 and player 2
    self.player1:update(dt)
    self.player2:update(dt)

    -- Update the ball
    self.ball:update(dt)
    
    if self.ball:collides(self.player1) then
        gSounds['paddle_hit']:play()
        self.ball.x = self.ball.x - 4
        self.ball.dx = -self.ball.dx * 1.03 
    end

    if love.keyboard.isDown('w') then
        self.player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        self.player1.dy = PADDLE_SPEED
    else
        self.player1.dy = 0
    end

    if love.keyboard.isDown('up') then
        self.player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        self.player2.dy = PADDLE_SPEED
    else
        self.player2.dy = 0
    end
end

function PlayState:render()
    self.player1:render()
    self.player2:render()
    self.ball:render()
end