Player = Class:extend()

-- Player:init(image)
function Player:init(image)

    -- Initialize variables
    self.x = 0
    self.y = 0
    self.dx = 0
    self.size = 'small'
    self.image = love.graphics.newImage(image)
    self.momentum_factor = 0
    self.moving = false
end

-- Player:update(dt)
function Player:update(dt)

    -- If the d key is down at any point
    if love.keyboard.isDown('d') then

        -- Set the moving state to be true
        self.moving = true

        -- Set player's delta x to be 10 pixels * momentum factor
        self.dx = 10 * self.momentum_factor

        -- Change player position based on delta x
        self.x = self.x + self.dx
    end

    -- If the a key is down at any point
    if love.keyboard.isDown('a') then

        -- Set the moving state to be true
        self.moving = true

        -- Set player's delta x to be 10 pixels * momentum factor
        self.dx = 10 * self.momentum_factor

        -- Change player position based on delta x
        self.x = self.x - self.dx
    end

    -- If the player isn't moving and his momentum should be reset
    if self.moving == false and self.momentum_factor > 0 then

        -- Lower down momentum factor each frame
        self.momentum_factor = self.momentum_factor - 10 * dt
    end

    -- If the spacebar is down at any point
    if love.keyboard.isDown('space') then
    end

    if love.keyboard.isDown('a') then
        
    end
    -- If the player is moving
    if self.moving then

        -- Increment momentum factor each frame
        self.momentum_factor = self.momentum_factor + 1 * dt
    end
end

-- Player:draw()
function Player:draw()
    
    -- Draw the image at specified x and y
    love.graphics.draw(self.image, self.x, self.y)
end