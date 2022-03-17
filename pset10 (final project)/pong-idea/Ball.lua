Ball = Class:extend()

-- Virtual height and virtual width
local const VIRTUAL_HEIGHT = 432
local const VIRTUAL_WIDTH = 243

--[[ 
    Ball:init() 
    Called when initializing the ball object
]]
function Ball:init(x, y)

    -- Ball's X and Y coordinates right in the center
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2

    -- Ball's height and width
    self.height = 4
    self.width = 4

    -- Ball's direction to go in is defined by delta x and delta y
    self.dx = 0
    self.dy = 0
end

--[[
    Ball:collides(paddle)
    Called every frame to check if the ball collides with the paddle
]]
function Ball:collides(paddle)
    --[[ 
        AABB Collision Detection Algorithm to figure out if the ball is colliding with the paddle
        It works by checking if the ball's X is less than the paddle's X + the paddle's width and
        if the paddle's X is less than the ball's X + the ball's width

        Then, check if the ball's Y is less than the paddle's Y + the paddle's height and
        the paddle's Y is less than the ball's Y + the ball's height
    ]]
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end
    
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end

    -- if the above aren't true, they're overlapping
    return true
end

--[[
    Ball:reset()
    Resets the ball into the middle of the screen
]]
function Ball:reset()
    -- Reset X and Y values
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
end
--[[
    Ball:update(dt)
    Called every frame inside of love.update(dt)
]]
function Ball:update(dt)

    --[[
        Change the current object's X and Y values depending on
        the location of the direction the X and Y are supposed to be heading 
    ]]
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:draw()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end