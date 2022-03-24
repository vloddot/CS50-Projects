DoneState = Class{__includes = BaseState}

--[[
    DoneState:enter(params)
    Called whenever the state is entered, takes as arguments the info of the player and ball objects
]]
function DoneState:enter(params)
    self.player1 = params.player1
    self.player2 = params.player2
    self.ball = params.ball
    self.player_count = params.player_count
end

--[[
    DoneState:update(dt)
    Called every frame while we're inside of the state
]]
function DoneState:update(dt)

    -- Update both players
    self.player1:update(dt)
    self.player2:update(dt)

    if love.keyboard.wasPressed('return') then

        -- Reset scores
        self.player1.score = 0
        self.player2.score = 0

        self.ball:reset()
        -- Change the state to the serve states and pass in the objects
        gStateMachine:change('serve', {
            player1 = self.player1,
            player2 = self.player2,
            ball = self.ball,
            player_count = self.player_count
        })
    end
end

--[[
    DoneState:render()
    Called after DoneState:update(dt) finishes with its code
]]
function DoneState:render()

    -- Render both players
    self.player1:render()
    self.player2:render()

    -- Don't render the ball because we don't need it in this state

    -- Set the font to the small font from the global fonts table
    love.graphics.setFont(gFonts['small'])

    -- UI message to promprt the user for another round and say who won
    love.graphics.printf('Player ' .. (self.player1.serving and 1 or 2) .. ' won!', 0, 10, VIRTUAL_WIDTH , 'center')
    love.graphics.printf('Press \"Enter\" to restart!', 0, 20, VIRTUAL_WIDTH ,'center')

    -- Set the font to the large font from the global fonts table
    love.graphics.setFont(gFonts['large'])

    -- Player 1 and 2's scores
    love.graphics.print(self.player1.score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(self.player2.score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end