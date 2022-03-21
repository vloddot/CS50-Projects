require 'src/Dependencies'

local fps = false

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    gSounds = {
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static')
    }

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['serve'] = function() return ServeState() end,
        ['play'] = function() return PlayState() end,
        ['done'] = function() return DoneState() end
    }

    gStateMachine:change('start')
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    gStateMachine:update(dt)
end

--[[
    love.keypressed(key)
    Gets called whenever a key is pressed
    Takes as arguments the current pressed key
]]
function love.keypressed(key)

    -- Show FPS
    if key == 'f' then
        fps = true
    end

    -- Quit the game
    if key == 'esacpe' then
        love.event.quit(0)
    end
end
function love.draw()
    push:start()
    
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- gStateMachine:draw()

    if fps then
        displayFPS()
    end

    push:finish()
end

local function displayFPS()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0/255, 255/255, 0/255, 255/255)
    love.graphics.print('FPS: ' .. love.timer.getFPS(), 5, 5)
end