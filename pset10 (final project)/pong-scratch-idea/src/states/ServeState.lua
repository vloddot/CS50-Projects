ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
    self.paddles = params.paddles
    self.ball = params.ball
    self.playerNum = params.playerNum
end

function ServeState:update(dt)
    if love.keyboard.wasPressed('return') then 
        gStateMachine:change('play', {
            paddles = self.paddles,
            ball = self.ball,
            playerNum = self.playerNum,
        })
    end

    if self.playrNum == 2 then 
        if love.keyboard.isDown('w') then 
            self.paddles[1].dy = -PADDLE_SPEED

        elseif love.keyboard.isDown('s') then
            self.paddles[1].dy = PADDLE_SPEED
        else
            self.paddles[1].dy = 0
        end
    
        if love.keyboard.isDown('up') then 
            self.paddles[2].dy = -PADDLE_SPEED
        
        elseif love.keyboard.isDown('down') then
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
end

function ServeState:render()
    self.paddles[1]:draw()
    self.paddles[2]:draw()
    self.ball:draw()

    for k, paddle in pairs(self.paddles) do
        paddle:draw()
    end

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Player " .. tostring(self.playerNum) .. " serve!", 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Press Enter to serve!", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end