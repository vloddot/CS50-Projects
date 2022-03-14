-- Define window resolution using love
local const WINDOW_HEIGHT = love.graphics.getHeight()
local const WINDOW_WIDTH = love.graphics.getWidth()

-- Define virtual resolution
local const VIRTUAL_HEIGHT = 1600
local const VIRTUAL_WIDTH = 1200  

-- Set gamestate to be the title screen
gameState = 'title_screen'

-- Push library
-- Taken from https://github.com/Ulydev/push
-- Useful for putting a virtual resolution on the game
local push = require 'push'

-- Retro font used for text in-game
local largeFont = love.graphics.newFont('font.ttf', 32)

-- printx and printy for outputting the X and O
printx = 0
printy = 0

-- love.load()
function love.load()

    -- Window title
    love.window.setTitle('Tic tac toe!')

    -- Set the default filter to use nearest neighbor antialiasing techniques which improves retro feel and look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Class library
    -- Taken from https://github.com/jonstoler/class.lua
    require 'class'
    
    -- Player.lua class
    require 'Player'

    -- Player x and player o take a boolean value depending on if they're x or o (class' code found in Player.lua)
    playerX = Player(true)
    playerO = Player(false)

    -- Setup screen using push's setup screen function which resizes window to use a virtual resolution
    push:setupScreen(WINDOW_WIDTH, WINDOW_HEIGHT, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

end

-- love.resize(w, h)
function love.resize(w, h)
    push:resize(w, h)
end
-- love.keypressed(key)
function love.keypressed(key)

    -- Quit the game
    if key == 'escape' then
        love.event.quit(0)
    end

    -- Restart the game
    if key == 'r' then
        love.event.quit('restart')
    end

    -- Enter the start game state
    if key == 'return' and gameState == 'title_screen' then
        gameState = 'x_turn'
    end

    -- Enter fullscreen mode
    if key == 'f' then
        push:switchFullscreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    end

    -- Debugging key for switching to o turn
    if key == 'o' then
        gameState = 'o_turn'
    end

    -- Debugging key for switch to x turn
    if key == 'x' then
        gameState = 'x_turn'
    end
end

-- love.mousepressed(x, y, button, istouch)
function love.mousepressed(x, y, button, istouch)

    -- Set printx and printy for the bottom left corner of the board
    if x > 275 and x < 350 and y > 600 and y < 700 then
        printx = 315
        printy = 650

    elseif x > 350 and x < 700 and y > 600 and y < 700 then
        printx = 525
        printy = 650

    elseif x > 700 and x < 775 and y > 600 and y < 700 then
        printx = 740
        printy = 650

    elseif x > 275 and x < 350 and y > 400 and y < 600 then
        printx = 315
        printy = 500

    elseif x > 350 and x < 700 and y > 400 and y < 600 then
        printx = 525
        printy = 500

    elseif x > 700 and x < 775 and y > 400 and y < 600 then
        printx = 740
        printy = 500

    elseif x > 275 and x < 350 and y > 300 and y < 400 then
        printx = 315
        printy = 350

    elseif x > 350 and x < 700 and y > 300 and y < 400 then
        printx = 525
        printy = 350

    elseif x > 700 and x < 775 and y > 300 and y < 400 then
        printx = 740
        printy = 350

    end
end

local waiting = false
local waitTimer = 0.5
-- love.update(dt)
function love.update(dt)
    
end
function get_board_location(y, x)
    if x > 275 and x < 350 and y > 600 and y < 700 then
        return 3, 1

    elseif x > 350 and x < 700 and y > 600 and y < 700 then
        return 3, 2
        
    elseif x > 700 and x < 775 and y > 600 and y < 700 then
        return 3, 3
        
    elseif x > 275 and x < 350 and y > 400 and y < 600 then
        return 2, 1

    elseif x > 350 and x < 700 and y > 400 and y < 600 then
        return 2, 2
        
    elseif x > 700 and x < 775 and y > 400 and y < 600 then
        return 2, 3

    elseif x > 275 and x < 350 and y > 300 and y < 400 then
        return 1, 1

    elseif x > 350 and x < 700 and y > 300 and y < 400 then
        return 1, 2

    elseif x > 700 and x < 775 and y > 300 and y < 400 then
        return 1, 3
        
    else
        return 1, 1
    end
end


-- love.draw()
function love.draw()

    -- Set gray background while playing
    love.graphics.clear(43/255, 50/255, 52/255, 255/255)

    love.graphics.setFont(largeFont)

    love.graphics.print('FPS: ' .. love.timer.getFPS(), 100, 50)
    -- If the player is in the title screen state
    if gameState == 'title_screen' then

        -- Draw the two welcome messages
        love.graphics.printf("Hello, Tic-tac-toe!", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press \"Enter\" to start", 0, VIRTUAL_HEIGHT / 3 + 40, VIRTUAL_WIDTH, 'center')
    end

    -- If the player is in the two turn states of the game
    if gameState == 'x_turn' or gameState == 'o_turn' then

        -- Creating rows
        for i = 1, 3 do
            love.graphics.line(275, 800 / (i / 1.5), 775, 800 / (i / 1.5))
        end
        
        -- X and Y coordinate pointer, very useful for debugging
        love.graphics.print("X: " .. love.mouse.getX(), 100, 100)
        love.graphics.print("Y: " .. love.mouse.getY(), 100, 200)
        
        -- Creating columns
        for i = 1, 2 do
            love.graphics.line(350 * i, 300, 350 * i, 700)
        end

        playerO:draw(printx, printy, 500, 600)
        -- playerX:draw(300, 400, 500, 600)
    end

    -- Write a turn message for the two players
    if gameState == 'x_turn' then
        love.graphics.print("Player x's turn!", 255, 266)
    elseif gameState == 'o_turn' then
        love.graphics.print("Player O's turn!", 255, 266)
    end
end