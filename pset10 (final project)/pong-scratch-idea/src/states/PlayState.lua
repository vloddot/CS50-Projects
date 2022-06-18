PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.paddles = params.paddles
    self.ball = params.ball
    self.playerNum = params.playerNum
    self.paused = false
end

function PlayState:checkVictory()
    if self.paddles[1].score == 10 then
        gStateMachine:change('victory', {
            player = 1,
            score = self.paddles[1].score,
        })
    elseif self.paddles[2].score == 10 then
        gStateMachine:change('victory', {
            player = 2,
            score = self.paddles[2].score,
        })
    end    
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('space') then
        self.paused = not self.paused
    end

    if self.paused then
        return
    end

    if self.playerNum == 2 then 
        if love.keyboard.isDown('w') then 
            self.paddles[1].dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('s') then
            self.paddles[1].dy = PADDLE_SPEED
        else
            self.paddles[1].dy = 0
        end

        if love.keyboard.wasPressed('up') then 
            self.paddles[2].dy = -PADDLE_SPEED
        elseif love.keyboard.wasPressed('down') then
            self.paddles[2].dy = PADDLE_SPEED
        else
            self.paddles[2].dy = 0
        end

    elseif self.playerNum == 1 then 
        if love.keyboard.isDown('w') then 
            self.paddles[1].dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('s') then
            self.paddles[1].dy = PADDLE_SPEED
        else
            self.paddles[1].dy = 0
        end

        -- Implement AI for player 2
        if self.ball.y < self.paddles[2].y then 
            self.paddles[2].dy = -PADDLE_SPEED + 100
        elseif self.ball.y > self.paddles[2].y then
            self.paddles[2].dy = PADDLE_SPEED - 100
        else
            self.paddles[2].dy = 0
        end
    end

    self.paddles[1]:update(dt)
    self.paddles[2]:update(dt)

    self.ball:update(dt)

    if self.ball:collides(self.paddles[1]) then
        self.ball.dx = -self.ball.dx * 1.03
        self.ball.x = self.paddles[1].x + 5

        gSounds['paddle-hit']:play()

    end

    if self.ball:collides(self.paddles[2]) then
        self.ball.dx = -self.ball.dx * 1.03
        self.ball.x = self.paddles[2].x - 4


        self.paddles[2].score = self.paddles[2].score + 1
        gSounds['paddle-hit']:play()
    end

    if self.ball.y <= 0 then
        self.ball.y = 0
        self.ball.dy = -self.ball.dy
        gSounds['wall-hit']:play()
    end

    if self.ball.y >= VIRTUAL_HEIGHT - 4 then
        self.ball.y = VIRTUAL_HEIGHT - 4
        self.ball.dy = -self.ball.dy
        gSounds['wall-hit']:play()
    end

    if self.ball.x < 0 then
        self.paddles[2].score = self.paddles[2].score + 1
        gSounds['score']:play()
        gStateMachine:change('serve', {
            playerNum = self.playerNum,
        })
    end

    if self.ball.x > VIRTUAL_WIDTH then
        self.paddles[1].score = self.paddles[1].score + 1
        gSounds['score']:play()
        gStateMachine:change('serve', {
            playerNum = self.playerNum,
        })
    end
end