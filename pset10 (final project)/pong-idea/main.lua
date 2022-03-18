-- Load in the push library to set up a virtual resolution instead of user's current resolution
local push = require 'push'

-- Load in the class library to add functionality for paddle and ball classes
require 'class'

-- Load in the paddle class (found in Paddle.lua)
require 'Paddle'

-- Load in the ball class (found in Ball.lua)
require 'Ball'

-- The number of players the user chooses
local player_count = 0

-- The size of our actual window
local const WINDOW_WIDTH = love.graphics.getWidth()
local const WINDOW_HEIGHT = love.graphics.getHeight()

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

-- Fonts table to load inside of love.draw() of 3 sizes (8, 16, and 32)
local fonts = {
    ['small'] = love.graphics.newFont("font.ttf", 8),
    ['medium'] = love.graphics.newFont("font.ttf", 16),
    ['large'] = love.graphics.newFont("font.ttf", 32)
}

-- Sounds table to load inside of love.update(dt) for example, when the player hits the wall, we play paddle_hit and when the ball's X is past the virtual width, we play score, and when the ball hits either of the top or bottom walls, we play wall_hit
local sounds = {
    ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
}

-- Boolean value to check if the user wants the FPS to be shown or not
local fps = false

-- Boolean value to check if the user wants the X and Y coordinates to be shown or not
local coordinates = false

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

    -- Restart the game
    elseif key == 'r' then
        love.event.quit('restart')
    end

    -- Toggle showing FPS
    if key == 'f' then
        if fps then
            fps = false
        else
            fps = true
        end
    end

    -- Toggle showing X and Y coordinates for mouse
    if key == 'x' then
        if coordinates then
            coordinates = false
        else
            coordinates = true
        end
    end

    --[[
        Enter multiple states based on 1 button (return)

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
        -- If the gamestate is the start state
        if gameState == 'start' then

            -- Set gamestate to be the serving state
            gameState = 'serving'
        
        -- If the gamestate is serving
        elseif gameState == 'serving' then

            -- Set gamestate to be play
            gameState = 'play'

        -- If the gamestate is the done state
        elseif gameState == 'done' then

            -- Set the gamestate to be the serving state
            gameState = 'serving'
            
            -- Reset the ball's X and Y values
            ball:reset()

            -- Reset scores
            player1.score = 0
            player2.score = 0

            -- If player 1 won
            if player1.won then

                -- Set player 2 to serve
                player2.serving = true
                player1.serving = false

            -- Else (player 2 won)
            else

                -- Set player 1 to serve
                player1.serving = true
                player2.serving = false
            end
        end
    end

    -- These two are for changing the number of players the user wants

    -- If the user entered 'up arrow'
    if key == 'up' and gameState == 'start' and player_count <= 1 and player_count >= 0 then

        -- Increment player count by 1
        player_count = player_count + 1
    
    -- If the user entered 'down arrow'
    elseif key == 'down' and gameState == 'start' and player_count <= 2 and player_count > 0 then

        -- Decrement player count by 1
        player_count = player_count - 1
    end
end

--[[
    love.update(dt)
    Called every frame
    Passed argument is dt (stands for delta time) which is basically:
        The time which passed since love.update(dt) was last called
]]
function love.update(dt)

    --[[
        If there is 1 player to play
        Set an AI and a player
    ]]
    if player_count == 1 then

        -- AI movement
        if player1.y < ball.y then
            player1.dy = PADDLE_SPEED - 100

        elseif player1.y > ball.y then
            player1.dy = -PADDLE_SPEED + 100
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
    --[[
        If there are 2 players to play
        Set two players
    ]]
    elseif player_count == 2 then

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
    
    --[[
        Else (player_number == 0)
        Set two AIs
    ]]
    else

        -- AI 1 movement
        if player1.y < ball.y then
            player1.dy = PADDLE_SPEED

        elseif player1.y > ball.y then
            player1.dy = -PADDLE_SPEED
        else
            player1.dy = 0
        end

        -- AI 2 movement
        if player2.y < ball.y then
            player2.dy = PADDLE_SPEED

        elseif player2.y > ball.y then
            player2.dy = -PADDLE_SPEED
        else
            player2.dy = 0
        end
    end

    
    -- If the gamestate is serving
    if gameState == 'serving' then

        -- Set the ball's delta Y to be a random number between -50 and 50
        ball.dy = math.random(-50, 50)

        -- If player 1 is serving
        if player1.serving then

            -- Set the ball's delta X to be a random number between 140 and 200
            ball.dx = math.random(140, 200)
        
        -- Else (player 2 is serving)
        else

            -- Set the ball's delta X to be a random number between -140 and -200
            ball.dx = -math.random(140, 200)
        end
        
    -- If the gamestate is play
    elseif gameState == 'play' then

        -- If the ball collides with player 1
        if ball:collides(player1) then

            -- Multiply ball's delta X by 1.03 and push it in the other direction
            ball.dx = -ball.dx * 1.03

            -- Move the ball away from the player so that it doesn't re-collide
            ball.x = player1.x + 5

            -- If the ball's delta Y is less than 0
            if ball.dy < 0 then

                -- Set the ball's delta Y to be a random number from -10 to -150
                ball.dy = -math.random(10, 150)

            -- Else (delta Y is bigger than or equals 0)
            else

                -- Set the ball's delta Y to be a random number from 10 to 150
                ball.dy = math.random(10, 150)
            end

            -- Play the paddle_hit sound
            sounds['paddle_hit']:play()
        
        -- If the ball collides with player 2
        elseif ball:collides(player2) then

            -- Multiply ball's delta X by 1.03 and push it in the other direction
            ball.dx = -ball.dx * 1.03

            -- Move the ball away from the player so that it doesn't re-collide
            ball.x = player2.x - 4

            -- If the ball's delta Y is less than 0
            if ball.dy < 0 then

                -- Set the ball's delta Y to be a random number between -10 and -150
                ball.dy = -math.random(10, 150)

            -- Else (ball's delta Y is bigger than or equals 0)
            else

                -- Set the ball's delta Y to be a random number between 10 and 150
                ball.dy = math.random(10, 150)
            end

            -- Play the paddle_hit sound
            sounds['paddle_hit']:play()
        end

        -- If the ball's Y is less than or equals 0 (meaning ball hit the top of the screen)
        if ball.y <= 0 then

            -- Reset ball's y to 0
            ball.y = 0

            -- Reverse ball's delta Y
            ball.dy = -ball.dy

            -- Play the wall_hit sound
            sounds['wall_hit']:play()
        end

        -- If the ball's Y is less than or equals the height of the virtual screen and -4 to accommodate for the ball's size
        if ball.y >= VIRTUAL_HEIGHT - 4 then

            -- Reset ball's Y to equal the height of the virtual screen and -4 to accommodate for the ball's size
            ball.y = VIRTUAL_HEIGHT - 4

            -- Reverse ball's delta Y
            ball.dy = -ball.dy

            -- Play the wall_hit sound
            sounds['wall_hit']:play()
        end

        -- If the ball went past the edge of the screen in player 1's side
        if ball.x < 0 then

            -- Player 1 serves
            player1.serving = true

            -- Increment player score
            player2.score = player2.score + 1

            -- If player 2's score is 10 (meaning player 2 won)
            if player2.score == 10 then

                -- Player 2 won
                player2.won = true

                -- Set gamestate to be done
                gameState = 'done'

            -- Else (score is less than 10)
            else

                -- Set gamestate to be serving
                gameState = 'serving'

                -- Reset ball's X and Y
                ball:reset()
            end

            -- Play the score sound
            sounds['score']:play()
        end

        -- If the ball want past the edge of the screen in player 2's side
        if ball.x > VIRTUAL_WIDTH then

            -- Player 2 serves
            player2.serving = true

            -- Increment player 1's score
            player1.score = player1.score + 1

            -- If player 1's score is 10 (meaning player 1 won)
            if player1.score == 10 then

                -- Player 2 won
                player1.won = true

                -- Set gamestate to be done
                gameState = 'done'

            -- Else (Player 1's score is less than 10)
            else
                -- Set gamestate to be serving
                gameState = 'serving'

                -- Reset the ball's X and Y
                ball:reset()
            end
        end
    end


    -- Set the servingPlayer variable to be the current serving player
    if player1.serving then
        servingPlayer = 1
    else
        servingPlayer = 2
    end

    -- Set the winningPlayer variable to be the player that won
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

    -- Print X and Y positions for mouse at (10, 20) and (10, 30)
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
    love.graphics.print(player1.score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3 + 10)
    
    -- Print player 2's score
    love.graphics.print(player2.score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3 + 10)
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

    -- UI Messages are in this chain of if, elseif
    if gameState == 'start' then

        -- Use the small font from the fonts table
        love.graphics.setFont(fonts['small'])

        -- Print "This is pong!"
        love.graphics.printf("This is Pong!", 0, 10, VIRTUAL_WIDTH, 'center')

        -- Print "Choose options and press \"Enter\" to begin!"
        love.graphics.printf("Choose options and press \"Enter\" to begin!", 0, 20, VIRTUAL_WIDTH, 'center')

        -- If the player count is bigger than 0
        if player_count > 0 then

            -- Print "Number of players (change using up and down arrow keys)"
            love.graphics.printf("Number of players (change using up and down arrow keys)", 0, 30, VIRTUAL_WIDTH, 'center')
        -- Else (player count is 0)
        else
            -- Print "Number of players (change using up and down arrow keys, using 2 AIs is broken)"
            love.graphics.printf("Number of players (change using up and down arrow keys, using 2 AIs is broken)", 0, 30, VIRTUAL_WIDTH, 'center')
        end

        -- Print the player count
        love.graphics.printf(player_count, 0, 40, VIRTUAL_WIDTH, 'center')

        -- Print "Press \"Escape\" to quit the game at any time"
        love.graphics.printf("Press \"Escape\" to quit the game at any time", 0, 50, VIRTUAL_WIDTH, 'center')

        -- Print "Press \"r\" to restart the game at any time"
        love.graphics.printf("Press \"r\" to restart the game at any time", 0, 60, VIRTUAL_WIDTH, 'center')

        -- Print "Press \"f\" to toggle FPS display"
        love.graphics.printf("Press \"f\" to toggle FPS display", 0, 70, VIRTUAL_WIDTH, 'center')

        -- Print "Press \"x\" to toggle coordinates display"
        love.graphics.printf("Press \"x\" to toggle coordinates display", 0, 80, VIRTUAL_WIDTH, 'center')

    elseif gameState == 'serving' then

        -- Use the small font from the fonts table
        love.graphics.setFont(fonts['small'])

        -- Print the current serving player
        love.graphics.printf("Player " .. servingPlayer .. "'s serve!", 0, 10, VIRTUAL_WIDTH, 'center')

        -- Print "Press \"Enter\" to serve!"
        love.graphics.printf("Press \"Enter\" to serve!", 0, 20, VIRTUAL_WIDTH, 'center')

    elseif gameState == 'play' then
        -- No UI messages to send

    elseif gameState == 'done' then

        -- Use the medium font from the fonts table
        love.graphics.setFont(fonts['medium'])

        -- Print the winning player
        love.graphics.printf("Player " .. winningPlayer .. " wins!", 0, 10, VIRTUAL_WIDTH, 'center')

        -- Use the small font from the fonts table
        love.graphics.setFont(fonts['small'])

        -- Print "Press \"Enter\" to restart"
        love.graphics.printf("Press \"Enter\" to restart!", 0, 30, VIRTUAL_WIDTH, 'center')
    end

    -- Call the paddle draw functions to display the two paddles on the screen
    player1:draw()
    player2:draw()

    -- Call the ball draw functions to display the ball on the screen
    ball:draw()

    -- Display the FPS at location 10, 10 if the user wants to display FPS
    if fps then
        displayFPS()
    end

    -- Display both players' scores
    displayScore()

    -- Display current mouse's X and Y coordinates at locations 10, 20 and 10, 30 if the user wants to display them
    if coordinates then
        displayMouseLocation()
    end

    -- End the push library's code
    push:finish()
end