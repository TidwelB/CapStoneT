battery2 = {}
    battery2.spritesheet = love.graphics.newImage("sprites/battery.png")
    battery2.x = 500
    battery2.y = 500
    battery2.h = battery2.spritesheet:getHeight()
    battery2.w = battery2.spritesheet:getWidth() 
    battery2.room = "levelOne"

function battery2:draw()
    if checkInventory(inventory, "battery2") == false then
    if battery2.room == room then
    love.graphics.draw(battery2.spritesheet,battery2.x,battery2.y)
    end
end
end