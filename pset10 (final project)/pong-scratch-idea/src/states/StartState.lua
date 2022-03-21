StartState = Class{__includes = BaseStartState}

function StartState:update(dt)
    if love.keyboard.wasPressed('return') then
        gStateMachine:change('serve')
    end
end
function StartState:render()
    -- Start State's UI messages
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Hello, Pong!", 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Choose options and press \"Enter\" to start", 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press \"Escape\" to quit the game at any time", 0, 30, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press \"f\" to toggle FPS display", 0, 40, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press \"x\" to toggle X and Y display", 0, 50, VIRTUAL_WIDTH, 'center')
end