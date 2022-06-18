StartState = Class{__includes = BaseState}

function StartState:init()
    self.playerNum = 1
end

function StartState:update(dt)
    if love.keyboard.wasPressed('return') then
        gSounds['paddle-hit']:play()
        gStateMachine:change('serve', {
            playerNum = self.playerNum,
            paddles = {Paddle(10, 30), Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30)},
            ball = Ball(),
        })
    end

    if love.keyboard.wasPressed('up') then
        self.playerNum = math.min(2, self.playerNum + 1)
        gSounds['paddle-hit']:play()
    end

    if love.keyboard.wasPressed('down') then
        self.playerNum = math.max(1, self.playerNum - 1)
        gSounds['paddle-hit']:play()
    end
end


function StartState:render()
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Enter to start!', 0, 10,
        VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Esc to quit!', 0, 20,
        VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press R to restart!', 0, 30,
        VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press F to toggle FPS!', 0, 40,
        VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Up Arrow and Down Arrow to choose number of players!', 0, 50,
        VIRTUAL_WIDTH, 'center')

    love.graphics.printf(self.playerNum, 0, 60,
        VIRTUAL_WIDTH, 'center')
end