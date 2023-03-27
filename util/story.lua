Gamestate = require 'libraries.gamestate'
story = {}
story = Gamestate.new()

function story:enter(from)
      self.from = from
      love.window.setMode(1920, 1080, {resizable=true, vsync=true, minwidth=400, minheight=300})
  end

function story:draw()
    self.from:draw()
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    
    love.graphics.clear(0, 0, 0) -- clear the screen with a dark gray color
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("This will be the story introduction", 100, 10)
    love.graphics.print("Someone can write this if they see fit", 100, 100)
    love.graphics.print("Important things to write would be that they need to talk to the scienctist once the game starts", 100, 200)
    love.graphics.print("As well as that to leave this screen they need to hit enter", 100, 300)
    love.graphics.print("Additionally anyhting about the game story would be amazing to add to this screen", 100, 400)
    love.graphics.print("This screen is in util.story for anyone who wants to code this", 100, 500)
    --will need to look into pausing this screen?
    --as well as saving?
    --anythign else?

    if love.keyboard.isDown('return') then
        love.timer.sleep(.15)
        Gamestate.switch(runGame)
    end
end
