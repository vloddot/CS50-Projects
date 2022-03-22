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
end

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
            ball = self.ball
        })
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

    -- UI message to indicate which player is serving
    love.graphics.printf("Player " .. (self.player1.serving and 1 or 2) .. '\'s serve', 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press \"Enter\" to serve", 0, 20, VIRTUAL_WIDTH, 'center')
end