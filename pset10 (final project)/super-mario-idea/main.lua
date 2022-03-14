-- User's current window with and height
local WINDOW_HEIGHT = love.graphics.getHeight()
local WINDOW_WIDTH = love.graphics.getWidth()

-- Virtual width and height hard coded into game
local VIRTUAL_HEIGHT = 1600
local VIRTUAL_WIDTH = 1200

-- Require the push library
local push = require 'push'

-- Require the class library
require 'class'

-- Require the player class defined in Player.lua
require 'Player'

-- love.load()
function love.load()
    
    -- Use nearest neighbor techniques for rendering the screen instead of linear
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Use the push library to set up the user's screen as easily as possible
    push:setupScreen(WINDOW_WIDTH, WINDOW_HEIGHT, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    -- Set game's title as "Hello, world!"
    love.window.setTitle("Fifty Mario Bros.")
end

-- Make a player object with the mario png as its drawn picture
local player = Player('pictures/mario.png')


-- love.resize(w, h)
function love.resize(w, h)
    push:resize(w, h)
end

-- love.update(dt)
function love.update(dt)
    player:update(dt)
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
end

function love.keyreleased(key)

    -- If any movement key was released at any moment, set player.moving to false
    if key == 'd' or key == 'a' or key == 'space' or key == 's' then
        player.moving = false
    end
end


-- love.draw()
function love.draw()

    -- Use the push library to set where to enable the filtering
    push:start()
    
    player:draw()

    push:finish()
end