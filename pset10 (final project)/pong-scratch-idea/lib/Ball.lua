Ball = Class{}

function Ball:init()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.width = 4
    self.height = 4
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end

function Ball:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    return true    
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
        gSounds['wall-hit']:play()
    end

    if self.y >= VIRTUAL_HEIGHT - self.height then
        self.y = VIRTUAL_HEIGHT - 4
        self.dy = -self.dy
        gSounds['wall-hit']:play()
    end

    if self.x >= VIRTUAL_WIDTH - self.width then
        gStateMachine:change('serve', {
            playerNum = 1,
        })
    end
end

function Ball:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end