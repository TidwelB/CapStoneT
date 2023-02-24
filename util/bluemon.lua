bluemon = {}
bluemon = Gamestate.new()

function bluemon:enter(from)
    self.from = from
    self.word = ""
end

function bluemon:update(dt)
   -- bluemon.update(dt)
end

function bluemon:draw()
    love.graphics.reset()
    --self.from:draw()
    love.graphics.printf("Enter the secret tunnel:", 0, love.graphics.getHeight()/2 - 64, love.graphics.getWidth(), "center")
    love.graphics.printf(self.word, 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
    
--love.graphics.printf(input, 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
end

function bluemon:textinput(t)
    -- append typed characters to the filename
    self.word = self.word .. t
end

function bluemon:keypressed(key)
    if key == "backspace" then
        -- remove the last character from the filename
        self.word = self.word:sub(1, #self.word-1)
    elseif key == "return" then
        if self.word == "cry" then
            Gamestate.push(win)
        end
    end
end