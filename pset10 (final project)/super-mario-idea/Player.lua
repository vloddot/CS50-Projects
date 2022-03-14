Player = Class:extend()

function Player:init(image)
    self.x = 0
    self.y = 0
    self.size = 'small'
    self.image = love.graphics.newImage(image)
end

local count = 0
local waiting = false

function love.keyreleased(key)
    if key == 'd' or key == 'space' or key == 'a' or key == 's' then
        waiting = false
        count = 0
    end
end
function Player:update(dt)
    if love.keyboard.isDown('d') then
        waiting = true
        self.x = self.x + 10 * count
    end

    if love.keyboard.isDown('a') then
        waiting = true
        self.x = self.x - 10 * count
    end

    if love.keyboard.isDown('space') then
        self.y = self.y - 50
    end
    if waiting == true then
        count = count + 1 * dt
    end
end

function Player:draw()
    love.graphics.draw(self.image, self.x, self.y)
end