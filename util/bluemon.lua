bluemon = {}
bluemon = Gamestate.new()
og = love.graphics.newImage("screens/secret.png")
secret = og
bluemon.answer = true
bluemon.timer = 0
function bluemon:enter(from)
    self.from = from
    self.word = ""
end

function bluemon:update(dt)

end

function bluemon:draw()
    self.from:draw()
   -- love.graphics.reset()
bluemon.timer = bluemon.timer +1
   local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    if secret ~= og then
        if bluemon.timer > 500 then
            secret = og
    end
    end
   love.graphics.draw(secret, 0, 0, 0, screenWidth / secret:getWidth(), screenHeight / greenpuzzle:getHeight())
   if love.keyboard.isDown('escape') then
       love.timer.sleep(.15)
       Gamestate.pop()
   end
    love.graphics.printf("Enter the secret tunnel:", 0, love.graphics.getHeight()/2 - 20, love.graphics.getWidth(), "center")
    love.graphics.printf(self.word, 0, love.graphics.getHeight()/2 + 10, love.graphics.getWidth(), "center")
end

function bluemon:textinput(t)
    self.word = self.word .. t
end

function bluemon:keypressed(key)
    if key == "backspace" then
        self.word = self.word:sub(1, #self.word-1)
    elseif key == "return" then
        if self.word == "secure contain protect" then
            Gamestate.pop(bluemon)
            --need to unlock/draw item that is from solving puzzle
        else
            print(self.word)
            secret = love.graphics.newImage("sprites/flashlight.png")
            bluemon.timer = 0
            self.word = ""
        end
    end
end


function bluemon.load()
    secret = love.graphics.newImage("screens/secret.jpg")
end
