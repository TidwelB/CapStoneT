flashlight = {}
    flashlight.spritesheet = love.graphics.newImage("sprites/flashlight.png")
    flashlight.x = 500
    flashlight.y = 200
    flashlight.h = flashlight.spritesheet:getHeight()
    flashlight.w = flashlight.spritesheet:getWidth()
    flashlight.scale = 0.1
    flashlight.room = "runGame"

function flashlight:draw()
    if checkInventory(inventory, "flashlight") == false then
    if flashlight.room == room then
        love.graphics.draw(flashlight.spritesheet,flashlight.x,flashlight.y,0,flashlight.scale,flashlight.scale)
    end
end

end