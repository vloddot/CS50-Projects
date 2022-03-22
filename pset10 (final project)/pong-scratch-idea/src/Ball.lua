Ball = Class{}

--[[
    Ball:init()
    Called when a ball object is instantiated
]]
function Ball:init()

    -- X and Y in the exact center of the screen
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2

    -- Delta X and delta Y values for changing the X and Y inside of Ball:update(dt)
    self.dx = 0
    self.dy = 0

    -- Width and height to use inside of Ball:render()
    self.width = 4
    self.height = 4
end

--[[
    Ball:reset()
    Called at certain points of the game to reset the X, Y, delta X, and delta Y of the ball
]]
function Ball:reset()

    -- Reset X and Y to the center of the screen
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2

    -- Reset delta X and delta Y to make the ball not move at all
    self.dx = 0
    self.dy = 0
end

--[[
    Ball:update(dt)
    Called every frame to change the X and Y of the ball inside of src/states/PlayState.lua
]]
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

--[[
    Ball:collides(target)
    Called every frame in love.update(dt) in main to check if the ball collided with the paddle
]]
function Ball:collides(target)

    -- Using the AABB Collision Detection algorithm to detect colliding with the target and the ball
    return self.x < target.x + target.width and
           target.x < self.x + self.width and
           self.y < target.y + target.height and
           target.y < self.y + target.height
end

--[[
    Ball:render()
    Called after Ball:update(dt) finishes its code
]]
function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end