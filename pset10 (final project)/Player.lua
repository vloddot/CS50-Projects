Player = Class:extend()

function Player:init(xBool)
    self.xBool = xBool

    self.board = {
        {false, false, false},
        {false, false, false},
        {false, false, false}
    }
end

function Player:draw(x1, y1, x2, y2)

    if self.xBool then

        for i, row in ipairs(self.board) do
            for j, boolean in ipairs(row) do

                -- Show all of playerX's board values for debugging
                love.graphics.print(tostring(boolean), 200 + (j * 150), 100 + (i * 20))
                
                -- If the mouse is down and the user isn't clicking somewhere random
                if love.mouse.isDown(1) and (x1 ~= 0 or y1 ~= 0 or y2 ~= 0 or y2 ~= 0) then

                    -- Declare two variables called y and x for getting the exact location of where the user clicked inside the board
                    local y = 0
                    local x = 0

                    -- Function call to get the location of y and x
                    y, x = get_board_location(love.mouse.getY(), love.mouse.getX())

                    -- Set player X's current board value to be true
                    self.board[y][x] = true
                    gameState = 'o_turn'
                end            
            end
        end
    else
        for i, row in ipairs(self.board) do
            for j, boolean in ipairs(row) do

                -- Show all of playerO's board values for debugging
                love.graphics.print(tostring(boolean), 200 + (j * 150), 100 + (i * 20)) 

                -- If the mouse is down and the user isn't clicking somewhere random
                if (love.mouse.isDown(1) and (x1 ~= 0 or y1 ~= 0)) then

                    -- Declare two variables called y and x for getting the exact location of where the user clicked inside the board
                    local y = 0
                    local x = 0

                    -- Function call to get the location of y and x
                    y, x = get_board_location(love.mouse.getY(), love.mouse.getX())

                    -- Check to see if both players aren't inputting their mouse input in the same location
                    if self.board[y][x] == false and playerX.board[y][x] == false then

                        -- Set player O's current board value to be true
                        self.board[y][x] = true
                        gameState = 'x_turn'
                    end
                end
            end
        end
    end


    for i, row in ipairs(playerO.board) do
        for j, boolean in ipairs(row) do

            -- If the current board value is true, draw player O's board data in his specified locations
            if boolean then
                love.graphics.circle('line', x1, y1, 20)
            end
        end
    end

    for i, row in ipairs(playerX.board) do
        for j, boolean in ipairs(row) do
            
            -- If the current board value is true, draw player X's board data in his specified locations
            if boolean then
                love.graphics.line(x1, y1, x2, y2)
                love.graphics.line(x2, y1, x1, y2)
            end
        end
    end
end

