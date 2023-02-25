battery1 = {}
    battery1.spritesheet = love.graphics.newImage("sprites/battery.png")
    battery1.x = 400
    battery1.y = 400
    battery1.h = battery1.spritesheet:getHeight()
    battery1.w = battery1.spritesheet:getWidth() 
    battery1.room = "levelOne"

function battery1:draw()
    if checkInventory(inventory, "battery1") == false then
        if Gamestate.current() == runLevelOne or Gamestate.current() == runGame then
    if battery1.room == room then
    love.graphics.draw(battery1.spritesheet,battery1.x,battery1.y)
    end
end
end
end

function battery1.load()
    battery1.x = data.battery1.x
    battery1.y = data.battery1.y
    battery1.room = data.battery1.room
end