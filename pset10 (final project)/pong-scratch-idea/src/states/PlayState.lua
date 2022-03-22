--[[
    PlayState is the state when the two paddles play against eachother.
    It gets entered from within ServeState where the user gets prompted to serve
]]

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
    
    -- If the ball collides with player 1
    if self.ball:collides(self.player1) then

        -- Move the ball away from the player
        self.ball.x = self.ball.x + 4

        --[[
            Multiply delta X by 1.03 (to make the game a little more interesting) 
            and toggle its value from either positive to negative or negative to positive
        ]]
        self.ball.dx = -self.ball.dx * 1.03

        -- If the delta Y of the ball is less than 0
        if self.ball.dy < 0 then
            
            -- Set the ball's delta Y to be a random number between -10 and -150
            self.ball.dy = -math.random(10, 150)
            
            -- Else (ball's delta Y is bigger than or equals 0)
        else
            
            -- Set the ball's delta Y to be a random number between 10 and 150
            self.ball.dy = math.random(10, 150)
        end

        -- Play the paddle hit sound
        gSounds['paddle_hit']:play()

    -- If the ball collides with player 2
    elseif self.ball:collides(self.player2) then

         -- Move the ball away from the player
         self.ball.x = self.ball.x - 4

         --[[
            Multiply delta X by 1.03 (to make the game a little more interesting) 
            and push it in the other direction
         ]]
         self.ball.dx = -self.ball.dx * 1.03
 
         -- If the delta Y of the ball is less than 0
         if self.ball.dy < 0 then
             
            -- Set the ball's delta Y to be a random number between -10 and -150
            self.ball.dy = -math.random(10, 150)
             
            -- Else (ball's delta Y is bigger than or equals 0)
         else
             
            -- Set the ball's delta Y to be a random number between 10 and 150
            self.ball.dy = math.random(10, 150)
         end
 
         -- Play the 'paddle_hit' sound
         gSounds['paddle_hit']:play()
    end

    -- Player 1 movement
    if love.keyboard.isDown('w') then
        self.player1.dy = -PADDLE_SPEED

    elseif love.keyboard.isDown('s') then
        self.player1.dy = PADDLE_SPEED

    else
        self.player1.dy = 0
    end

    -- Player 2 movement
    if love.keyboard.isDown('up') then
        self.player2.dy = -PADDLE_SPEED

    elseif love.keyboard.isDown('down') then
        self.player2.dy = PADDLE_SPEED

    else
        self.player2.dy = 0
    end

    -- If the ball went past the edge of the screen in player 1's side
    if self.ball.x < 0 then

        -- Player 1 serves
        self.player1.serving = true

        -- Because the paddle class overwrites that value, set it to false
        self.player2.serving = false

        -- Increment player score
        self.player2.score = self.player2.score + 1

        -- If player 2's score is 10 (meaning player 2 won)
        if self.player2.score == 10 then

            -- Player 2 won
            self.player2.won = true

            -- Set gamestate to be done and pass in a bunch of objects for the non-instantiation loop
            gStateMachine:change('done', {
                player1 = self.player1,
                player2 = self.player2,
                ball = self.ball
            })

        -- Else (score is less than 10)
        else

            -- Set gamestate to be serve and pass in a bunch of objects for the non-instantiation loop
            gStateMachine:change('serve', {
                player1 = self.player1,
                player2 = self.player2,
                ball = self.ball
            })

            -- Reset ball's X and Y
            self.ball:reset()
        end

        -- Play the score sound
        gSounds['score']:play()

    -- If the ball went past the edge of the screen in player 1's side
    elseif self.ball.x > VIRTUAL_WIDTH then

        -- Player 2 serves
        self.player2.serving = true

        -- Because the paddle class overwrites we have to set it to false
        self.player1.serving = false

        -- Increment player 1's score
        self.player1.score = self.player1.score + 1

        -- If player 1's score is 10 (meaning player 1 won)
        if self.player1.score == 10 then

            -- Player 2 won
            self.player1.won = true

            -- Set gamestate to be done and pass in a bunch of objects for the non-instantiation loop
            gStateMachine:change('done', {
                player1 = self.player1,
                player2 = self.player2,
                ball = self.ball
            })

        -- Else (Player 1's score is less than 10)
        else
            -- Set gamestate to be serve and pass in a bunch of objects for the non-instantiation loop
            gStateMachine:change('serve', {
                player1 = self.player1,
                player2 = self.player2,
                ball = self.ball
            })

            -- Reset the ball's X and Y
            self.ball:reset()
        end

        -- Play the 'score' sound
        gSounds['score']:play()
    end

    -- If the ball is hitting the top part of the screen
    if self.ball.y <= 0 then

        -- Reset ball's Y to 0
        self.ball.y = 0
        
        -- Push ball into the other direction
        self.ball.dy = -self.ball.dy
        
        -- Play the 'wall_hit' sound
        gSounds['wall_hit']:play()
    
    -- If the ball is hitting the bottom part of the screen
    elseif self.ball.y >= VIRTUAL_HEIGHT - 4 then

        -- Reset the ball's Y to VIRTUAL_HEIGHT of the window - 4
        self.ball.y = VIRTUAL_HEIGHT - 4

        -- Push ball into the other direction
        self.ball.dy = -self.ball.dy

        -- Play the 'wall_hit' sound
        gSounds['wall_hit']:play()
    end
end

--[[
    PlayState:render()
    Called in love.draw() which is called after love.update(dt) finishes its code
    in the form of gStateMachine:render()
]]
function PlayState:render()

    -- Render both players
    self.player1:render()
    self.player2:render()

    -- Render ball
    self.ball:render()

    -- Set the current font to the large font from the fonts table
    love.graphics.setFont(gFonts['large'])

    -- Player 1 and 2's scores
    love.graphics.print(self.player1.score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(self.player2.score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end