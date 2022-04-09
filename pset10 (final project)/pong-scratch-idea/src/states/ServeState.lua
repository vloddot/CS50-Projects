--[[
    ServeState is the state where the serving player gets to, well 'serve' the ball.
    It usually gets called from within PlayState where the two players are playing together until
    the ball goes past the right or left edge of the screen.
    It can also get called from DoneState where one of the players won and the user is prompted to restart
]]

ServeState = Class{__includes = BaseState}

--[[
    ServeState:enter(params)
    Called whenever the ServeState is entered and is passed a bunch of parameters
    which are used to keep data without instantiating it over and over each state change
]]
function ServeState:enter(params)
    self.player1 = params.player1
    self.player2 = params.player2
    self.ball = params.ball
    self.player_count = params.player_count
end

--[[
    ServeState:update(dt)
    Called every frame when the gamestate is the serve state
]]
function ServeState:update(dt)

    -- If the return key was pressed in the current frame
    if love.keyboard.wasPressed('return') then

        --[[
            Change the state to the play state and pass in a couple of values in order to keep
            a loop going between serve then play then serve then play then done then we start over again
            which allows for keeping data without instantiating it over and over each state change
        ]]
        gStateMachine:change('play', {
            player1 = self.player1,
            player2 = self.player2,
            ball = self.ball,
            player_count = self.player_count
        })
    end

    --[[
        Big if, elseif chunk
        It's for using AI and players depending on player count chosen by user
    ]]
    -- If the player count is 2
    if self.player_count == 2 then

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

    -- If the player count is 1
    elseif self.player_count == 1 then

        -- AI movement
        if self.player1.y > self.ball.y then
            self.player1.dy = -PADDLE_SPEED + 80

        elseif self.player1.y < self.ball.y then
            self.player1.dy = PADDLE_SPEED - 80
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
    end

    -- Set the ball's delta Y to a random value between -50 and 50
    self.ball.dy = math.random(-50, 50)

    -- If player 1 is serving
    if self.player1.serving then
        
        -- Set the ball's delta X to a random value aiming at player 1's side
        self.ball.dx = math.random(140, 200)

    -- Else (player 2 is serving)
    else

        -- Set the ball's delta X to a random value aiming at player 2's side
        self.ball.dx = -math.random(140, 200)
    end

    -- Update both players
    self.player1:update(dt)
    self.player2:update(dt)

    -- Don't update self.ball because we don't want the ball to move while we're configuring ball's delta X and y
end

--[[
    ServeState:render()
    Called in love.draw() which is called after love.update(dt) finishes its current frame
]]
function ServeState:render()

    -- Render both players
    self.player1:render()
    self.player2:render()

    -- Render ball
    self.ball:render()

    -- Set font to be the small font from the global fonts table
    love.graphics.setFont(gFonts['small'])

    -- UI message to indicate which player is serving
    love.graphics.printf("Player " .. (self.player1.serving and 1 or 2) .. '\'s serve', 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press \"Enter\" to serve", 0, 20, VIRTUAL_WIDTH, 'center')

    -- Set font to be the large font from the global fonts table
    love.graphics.setFont(gFonts['large'])

    -- Player 1 and 2's scores
    love.graphics.print(self.player1.score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(self.player2.score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end