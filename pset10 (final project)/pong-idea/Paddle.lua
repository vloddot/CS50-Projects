Paddle = Class:extend()

local const WINDOW_HEIGHT = 1280
local const WINDOW_WIDTH = 720

local const VIRTUAL_HEIGHT = 432
local const VIRTUAL_WIDTH = 243
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

function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(self.y + self.dy * dt, 0)

    else
        self.y = math.min(self.y + self.dy * dt, VIRTUAL_HEIGHT - self.height)
    end
end

function Paddle:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end