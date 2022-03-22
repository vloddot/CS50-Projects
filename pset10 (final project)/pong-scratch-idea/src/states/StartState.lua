StartState = Class{__includes = BaseState}

--[[
    StartState:update(dt)
    Called every frame in love.update(dt) in the form of gStateMachine:update(dt)
]]
function StartState:update(dt)

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
            ball = Ball()
        })
    end
end

--[[
    StartState:render()
    Called after love.update(dt) finishes its course and moves onto love.draw()
    then called in love.draw() in the form of gStateMachine:update(dt)
]]
function StartState:render()

    -- Use the small font from the fonts table in ~/main.lua
    love.graphics.setFont(gFonts['small'])

    -- Start State's UI messages
    love.graphics.printf("Hello, Pong!", 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Choose options and press \"Enter\" to start", 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press \"Escape\" to quit the game at any time", 0, 30, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press \"f\" to toggle FPS display", 0, 40, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press \"x\" to toggle X and Y display", 0, 50, VIRTUAL_WIDTH, 'center')
end