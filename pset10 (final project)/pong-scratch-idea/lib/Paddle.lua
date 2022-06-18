Paddle = Class{}

function Paddle:init(x, y)
    self.x = x
    self.y = y
    self.width = 10
    self.height = 30
    self.dy = 0
end

function Paddle:update(dt)
    self.y = self.y + self.dy * dt
end

function Paddle:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end