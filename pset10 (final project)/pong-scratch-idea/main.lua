require 'src/Dependencies'

local showFPS = false

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Pong!')

    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }
    gSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }
    love.graphics.setFont(gFonts['small'])

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['serve'] = function() return ServeState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }

    gStateMachine:change('start')


    --[[
        Declare the global fonts array that houses
        small, medium, and large versions of the same font
    ]]
    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }

    -- Use the push library to push the screen resolution to a virtual width and height
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    --[[
        Declare a table which we will use to keep track of the pressed keys in the current frame
        which gets around the fact that we can't use the default callback function
        defined by LÖVE 2D (love.keypressed(key))
    ]]
    love.keyboard.keysPressed = {}
end

--[[
    love.resize(w, h)
    Called whenever the screen is resized by the user.
    We use the push library to resize the screen instead of having the headache
    of re-creating the wheel
]]
function love.resize(w, h)
    push:resize(w, h)
end

--[[
    love.update(dt)
    Called each frame to update variables and states
]]
function love.update(dt)

    --[[
        Call the current state from the global state machine
        which allows us to make functions for each state instead
        of putting them all in main.lua
    ]]
    gStateMachine:update(dt)
    
    -- Update love.keyboard.keysPressed to an empty table that is meant to get reset each frame
    love.keyboard.keysPressed = {}
end

--[[
    love.keypressed(key)
    Gets called whenever a key is pressed
    Takes as arguments the current pressed key
    This will include statements that we want
    in the entire life-course of the program
    instead of calling them in every state
    which is repetetive.
    It will also include an update of the love.keyboard.keysPressed
    table to use it in other files
]]
function love.keypressed(key)

    -- Set the current key of the love.keyboard.keysPressed table to be true
    love.keyboard.keysPressed[key] = true

    -- Toggle FPS display
    if key == 'f' then
        fps = not fps
        gSounds['paddle_hit']:play()
    end

    -- Quit the game
    if key == 'escape' then
        love.event.quit(0)
    end

    -- Toggle coordinate display
    if key == 'x' then
        coordinates = not coordinates
        gSounds['paddle_hit']:play()
    end

    if key == 'f' then
        showFPS = not showFPS
    end
end

--[[
    love.keyboard.wasPressed(key)
    This function is used to check if
    a certain key is pressed in the current
    frame, it returns the value of the
    key inside of the love.keyboard.keysPressed table
    which is boolean, true (pressed), false (not pressed)
]]
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--[[
    displayFPS()
    Used in love.draw() to show the FPS in 
    the upper-left part of the screen
]]
local function displayFPS()

    -- Set the font to the small font from the global fonts table
    love.graphics.setFont(gFonts['small'])

    -- Show FPS display
    love.graphics.print('FPS: ' .. love.timer.getFPS(), 10, 10)
end

--[[
    displayMouseLocation()
    Used in love.draw() to show the current X and Y
    coordinates of the mouse
]]
local function displayMouseLocation()

    -- Set the font to the small font from the global fonts table
    love.graphics.setFont(gFonts['small'])

    -- Show X and Y display
    love.graphics.print('X: ' .. love.mouse.getX(), 10, 20)
    love.graphics.print('Y: ' .. love.mouse.getY(), 10, 30)
end

--[[
    love.draw()
    Called after love.update(dt) finishes
    its code execution and is used to render
    the screen
]]
function love.draw()

    -- Start rendering using the push library
    push:start()
    
    -- Set a gray-ish background to the screen
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- Call the current state's render function
    gStateMachine:render()

    -- Render FPS
    if fps then
        displayFPS()
    end

    -- Render X and Y coordinates
    if coordinates then
        displayMouseLocation()
    end

    -- End rendering using the push library
    push:finish()
end
