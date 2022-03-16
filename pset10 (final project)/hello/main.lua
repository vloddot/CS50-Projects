function love.keypressed(key)
    
    if key == 'escape' then
        love.event.quit(0)
    end

    if key == 'r' then
        love.event.quit('restart')
    end
end

function love.draw()
    love.graphics.print("Hello, world!")
end