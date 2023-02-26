Gamestate = require 'libraries.gamestate'
computer5 = {}
computer5 = Gamestate.new()

function computer5:enter(from)
      self.from = from
      love.graphics.clear()
      love.graphics.reset()
  end

function computer5:draw()
    self.from:draw()
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    
    love.graphics.clear(0.2, 0.2, 0.2) -- clear the screen with a dark gray color
    love.graphics.setColor(1, 1, 1)

    love.graphics.print("Welcome to the computer lab! To get to the key item, you need to activate all four computers.", 100, 10)
    love.graphics.print("The first computer is in the top left corner, and it's a bit picky about its waveform. It likes something that's jagged but not too harsh. Can you give it the right wave?", 100, 40)
    love.graphics.print("The second computer is in the top right corner, and it's a bit of a rebel. It doesn't like the usual waveforms. Instead, it wants something that's edgy and unconventional. Can you figure out what kind of wave it wants?", 100, 60)
    if love.keyboard.isDown('escape') then
        love.timer.sleep(.15)
        Gamestate.pop()
    end
end
