Paddle = Class:extend()

-- Virtual height and Virtual width
local const VIRTUAL_HEIGHT = 432
local const VIRTUAL_WIDTH = 243

--[[
    Paddle:init(x, y, serving)
    This function is called whenever an object is created
        It takes as arguments an x and a y and a serving boolean value
        x is the horizontal position of the paddle
        y is the vertical position of the paddle
        score is the score of the player that is going to get incremented
        won is a boolean value which is used to check if the player has won or not
]] 
function Paddle:init(x, y, serving)
    self.x = x
    self.y = y
    self.width = 5
    self.height = 20
    self.dy = 0
    self.score = 0
    self.serving = serving
    self.won = false
end

--[[
    Paddle:update(dt)
    This function is called every frame in love.update(dt) in main.lua

]]
function Paddle:update(dt)

    -- If the delta Y is less than 0, meaning the player is going upwards
    if self.dy < 0 then

        -- Increment the Y value depending on the delta y while checking if player is hitting the top of the screen
        self.y = math.max(self.y + self.dy * dt, 0)
    
    -- Else (bigger than or equals 0)
    else
        -- Increment the Y value depending on the delta y while checking if player is hitting the bottom of the screen
        self.y = math.min(self.y + self.dy * dt, VIRTUAL_HEIGHT - self.height)
    end
end

--[[
    Paddle:draw()
    This function is called after love.update(dt) finishes its code in main.lua
]]
function Paddle:draw()
    -- Draw a rectangle of the paddle
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end