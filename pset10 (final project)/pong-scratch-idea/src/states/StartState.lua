--[[
    StartState is the state where the user gets to choose his options
    and is prompted to start playing using the 'return' key.
    This state is entered from main.lua and is the root of the program
]]

StartState = Class{__includes = BaseState}

--[[
    StartState:enter()
    Called when the start state is entered
]]
function StartState:enter()
    self.player_count = 1
end
--[[
    StartState:update(dt)
    Called every frame when the gamestate is the start state
]]
function StartState:update(dt)

    -- If the user pressed 'up arrow' on the keyboard and player_count won't get out of the 0-2 range
    if love.keyboard.wasPressed('up') and self.player_count <= 1 and self.player_count >= 0 then

        -- Increment player count by 1
        self.player_count = self.player_count + 1
    
    -- If the user pressed 'down arrow' on the keyboard and player_count won't get out of the 0-2 range
    elseif love.keyboard.wasPressed('down') and self.player_count <= 2 and self.player_count > 0 then

        -- Decrement player count by 1
        self.player_count = self.player_count - 1
    end

    -- If the return key was pressed in the current frame
    if love.keyboard.wasPressed('return') then

        --[[ 
            Change the global state machine to serve and pass in a couple of values
            so that it can loop around from ServeState into PlayState without re-instantiating the values
            which can be useful for keeping the data alive through the cycle of the program
        ]]
        gStateMachine:change('serve', {
            player1 = Paddle(10, 30, true),
            player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, false),
            ball = Ball(),
            player_count = self.player_count
        })
    end
end

--[[
    StartState:render()
    Called after StartState:update(dt) finishes its code.
]]
function StartState:render()

    -- Use the small font from the fonts table
    love.graphics.setFont(gFonts['small'])

    -- Start State's UI messages
    love.graphics.printf("Hello, Pong!", 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Choose the amount of needed players", 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Player count: " .. self.player_count, 0, 30, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Choose options and press \"Enter\" to start", 0, 40, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press \"Escape\" to quit the game at any time", 0, 50, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press \"f\" to toggle FPS display", 0, 60, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press \"x\" to toggle X and Y display", 0, 70, VIRTUAL_WIDTH, 'center')
end