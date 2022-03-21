Paddle = Class{}

function Paddle:init(x, y, serving)
    self.x = x
    self.y = y
    self.serving = serving
    
    self.dy = 0
    self.width = 5
    self.height = 20
end

function Paddle:update(dt)

    if love.keyboard.isDown('up') then

        self.dy = -PADDLE_SPEED
        
    elseif love.keyboard.isDown('down') then

        self.dy = PADDLE_SPEED
    end
    if self.dy > 0 then
        self.y = math.min(self.y + self.dy * dt, VIRTUAL_HEIGHT - self.height)
    else
        self.y = math.max(self.y + self.dy * dt, 0)
    end
end

function Paddle:draw()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end