-- Load in the push library to set up a virtual resolution instead of user's current resolution
local push = require 'push'

-- Load in the class library to add functionality for paddle and ball classes
require 'class'

-- Load in the paddle class (found in Paddle.lua)
require 'Paddle'

-- Load in the ball class (found in Ball.lua)
require 'Ball'

-- The size of our actual window
local const WINDOW_WIDTH = 1280
local const WINDOW_HEIGHT = 720

-- The size of the virtual width and virtual height to use the push library to load them easily without much frustration
local const VIRTUAL_WIDTH = 432
local const VIRTUAL_HEIGHT = 243

-- Paddle's movement speed
local const PADDLE_SPEED = 200

-- Create the two players from the paddle class
local player1 = Paddle(10, 30, true)
local player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, false)

-- Create the ball from the ball class
local ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2)

-- Create a serving player variable that's initially set to 1 because at the start the player that starts will be 1
local servingPlayer = 1

-- Create a winning player variable that's initially set to 0 because no one won at that point of the game
local winningPlayer = 0

-- Fonts table to load in inside of love.draw() of 3 sizes (8, 16, and 32)
local fonts = {
    ['small'] = love.graphics.newFont("font.ttf", 8),
    ['medium'] = love.graphics.newFont("font.ttf", 16),
    ['large'] = love.graphics.newFont("font.ttf", 32)
}

-- local sounds = {
--     ['paddle_hit'],
--     ['score'],
--     ['wall_hit']
-- }

-- Set the current gamestate to be the start state
local gameState = 'start'

--[[
    love.load()
    Called whenever the game starts up to load in constant things that will always be run at the start
]]
function love.load()

    -- Use nearest neighbor filtering techniques instead of linear filtering
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Set the window title to be "Pong!"
    love.window.setTitle('Pong!')

    -- Set the seed for randomness to be the OS's current time which varies on each runthrough so that the code doesn't do the same thing every single time
    math.randomseed(os.time())

    -- Use the push library's setupScreen function to virtually create a window with resizing and vsync
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
end

--[[
    love.resize(w, h)
    Called whenever user wants to resize the screen
    Also uses the push library to resize so that there aren't any problems in resizing using the virtual resolution
]]
function love.resize(w, h)
    push:resize(w, h)
end

--[[
    love.keypressed(key)
    Called whenever any key is pressed
    Passed argument is the pressed key
]]
function love.keypressed(key)

    -- Quit the game
    if key == 'escape' then
        love.event.quit(0)
    end

    --[[
        Enter multiple states based on 1 button

        If the gamestate is start then set gamestate to be serving,
        If the gamestate is serving then set the gamestate to be play,
        If the gamestate is done then set the gamestate to be serving then, do the following
            Reset the ball's location,
            Reset player score,
            If player 1 won then
                set the serve to be player 2
            Else
                set the serve to be player 1
    ]]
    if key == 'return' then
        if gameState == 'start' then
            gameState = 'serving'

        elseif gameState == 'serving' then
            gameState = 'play'

        elseif gameState == 'done' then
            gameState = 'serving'
            
            ball:reset()

            player1.score = 0
            player2.score = 0

            if player1.won then
                player2.serving = true
                player1.serving = false
            else
                player1.serving = true
                player2.serving = false
            end
        end
    end
end

--[[
    love.update(dt)
    Called every frame
    Passed argument is dt (stands for delta time) which is basically:
        The time which passed since love.update(dt) was last called
]]
function love.update(dt)

    -- Player 1 movement
    if love.keyboard.isDown("w") then
        player1.dy = -PADDLE_SPEED

    elseif love.keyboard.isDown("s") then
        player1.dy = PADDLE_SPEED

    else
        player1.dy = 0
    end

    -- Player 2 movement
    if love.keyboard.isDown("up") then
        player2.dy = -PADDLE_SPEED

    elseif love.keyboard.isDown("down") then
        player2.dy = PADDLE_SPEED

    else
        player2.dy = 0
    end

    if gameState == 'serving' then

        ball.dy = math.random(-50, 50)
        if player1.serving then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
        
    elseif gameState == 'play' then

        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

        elseif ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
        end

        if ball.x < 0 then
            player1.serving = true
            player2.score = player2.score + 1

            if player2.score == 10 then
                player2.won = true
                gameState = 'done'
            else
                gameState = 'serving'
                ball:reset()
            end
        end

        if ball.x > VIRTUAL_WIDTH then
            player2.serving = true
            player1.score = player1.score + 1

            if player1.score == 10 then
                player1.won = true
                gameState = 'done'

            else
                gameState = 'serving'
                ball:reset()
            end
        end
    end


    -- Set the serving player variable to be the current serving player
    if player1.serving then
        servingPlayer = 1
    else
        servingPlayer = 2
    end

    if player1.won then
        winningPlayer = 1

    else
        winningPlayer = 2
    end
    -- Call the paddle update functions found in Paddle.lua
    player1:update(dt)
    player2:update(dt)

    -- Call the ball update function found in Ball.lua if the game state is the play state
    if gameState == 'play' then
        ball:update(dt)
    end

    -- 2 functions should be added in turn to ask the user if he wants one player, two players, or just AI players playing
    -- AI1:update(dt)
    -- AI2:update(dt)
end

--[[
    displayFPS()
    Used in love.draw() in order to display the current FPS
]]
local function displayFPS()

    -- Use the small font from the fonts table
    love.graphics.setFont(fonts['small'])

    -- Print the FPS at position 10, 10
    love.graphics.print('FPS: ' .. love.timer.getFPS(), 10, 10)
end

--[[
    displayMouseLocation()
    Used in love.draw() in order to display the current mouse's X and Y positions
    These coordinates are drawn on 10, 20 and 10, 30
]]
local function displayMouseLocation()

    -- Use the small font from the fonts table
    love.graphics.setFont(fonts['small'])

    -- Print X and Y positions for mouse
    love.graphics.print("X: " .. love.mouse.getX(), 10, 20)
    love.graphics.print("Y: " .. love.mouse.getY(), 10, 30)
end

--[[
    displayScore()
    Called each time love.update(dt) is finished to display scores
]]
local function displayScore()

    -- Set current font to be the large font
    love.graphics.setFont(fonts['large'])

    -- Print player 1's score
    love.graphics.print(player1.score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    
    -- Print player 2's score
    love.graphics.print(player2.score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end
--[[
    love.draw()
    Called immediately after love.update(dt) in order to render in the game assets
]]
function love.draw()
    
    -- Start the push library's code
    push:start()

    -- Set the current font to be the medium font
    love.graphics.setFont(fonts['medium'])

    -- Set the background to be these special color values 40 for R, 45 for G, 52 for B, 255 for A
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    if gameState == 'start' then
        love.graphics.setFont(fonts['small'])
        love.graphics.printf("This is Pong!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Choose options and press \"Enter\" to begin!", 0, 20, VIRTUAL_WIDTH, 'center')
        -- love.graphics.rectangle('line', 200, 290, 70, 80)
    elseif gameState == 'serving' then
        love.graphics.setFont(fonts['small'])
        love.graphics.printf("Player " .. servingPlayer .. "'s serve!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press \"Enter\" to serve!", 0, 20, VIRTUAL_WIDTH, 'center')

    elseif gameState == 'play' then
        -- No UI messages to send

    elseif gameState == 'done' then
        love.graphics.setFont(fonts['medium'])
        love.graphics.printf("Player " .. winningPlayer .. " wins!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(fonts['small'])
        love.graphics.printf("Press \"Enter\" to restart!", 0, 30, VIRTUAL_WIDTH, 'center')
    end
    -- Call the paddle draw functions to display the two paddles on the screen
    player1:draw()
    player2:draw()

    -- Call the ball draw functions to display the ball on the screen
    ball:draw()

    -- Display the FPS at location 10, 10
    displayFPS()

    -- Display both players' scores
    displayScore()

    -- Display current mouse's X and Y coordinates at locations 10, 20 and 10, 30
    displayMouseLocation()

    -- End the push library's code
    push:finish()
end