gengar = {}
    gengar.spritesheet = love.graphics.newImage("sprites/gengar.png")
    gengar.x = 200
    gengar.y = 200
    gengar.h = gengar.spritesheet:getHeight()
    gengar.w= gengar.spritesheet:getWidth()
    gengar.room = "runGame"


function gengar:draw()
    if checkInventory(inventory, "gengar") == false then
    if gengar.room == room then
    love.graphics.draw(gengar.spritesheet,gengar.x,gengar.y)
    end
end

end
