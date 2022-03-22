Paddle = Class{}

--[[
    Paddle:init(x, y, serving)
    Called whenever a paddle object is instantiated.
    Used for setting the class' values
]]
function Paddle:init(x, y, serving)
    self.x = x
    self.y = y
    self.serving = serving
    
    self.dy = 0
    self.width = 5
    self.height = 20

    self.score = 0
    self.won = false
end

--[[
    Paddle:update(dt)
    Used to change the X and Y values of the paddle using dx and dy
]]
function Paddle:update(dt)

    -- If delta Y is bigger than 0, meaning the player wants to go down
    if self.dy > 0 then

        --[[ 
            Set the paddle's Y to self.y + self.dy * dt and the other argument for math.min
            is for if the user wants to go below the edge of the screen
        ]]
        self.y = math.min(self.y + self.dy * dt, VIRTUAL_HEIGHT - self.height)

    -- Else (delta Y is less than or equals 0), meaning the player wants to go up or is idle
    else

        --[[
            Set the paddle's Y to self.y + self.dy * dt and the other argument for math.max
            is for if the user wants to go above the edge of the screen
        ]]
        self.y = math.max(self.y + self.dy * dt, 0)
    end
end

--[[
    Paddle:render()
    Called in certain states of the game to render the paddle
]]
function Paddle:render()

    -- Draw a paddle rectangle
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end