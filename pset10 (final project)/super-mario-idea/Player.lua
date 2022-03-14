Player = Class:extend()

function Player:init(image)
    self.x = 0
    self.y = 0
    self.dx = 0
    self.size = 'small'
    self.image = love.graphics.newImage(image)
    self.count = 0
    self.moving = false
end

function Player:update(dt)

    if love.keyboard.isDown('d') then
        self.moving = true
        self.dx = 10 * self.count
        self.x = self.x + self.dx
    end

    if love.keyboard.isDown('a') then
        self.moving = true
        self.dx = 10 * self.count
        self.x = self.x - self.dx
    end

    if self.moving == false and self.count > 0 then
        self.count = self.count - 1 * dt
    end

    if love.keyboard.isDown('space') then
    end

    if self.moving == true then
        self.count = self.count + 1 * dt
    end
end

function Player:draw()
    love.graphics.draw(self.image, self.x, self.y)
end