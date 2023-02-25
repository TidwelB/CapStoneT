battery3 = {}
    battery3.spritesheet = love.graphics.newImage("sprites/battery.png")
    battery3.x = 600
    battery3.y = 600
    battery3.h = battery3.spritesheet:getHeight()
    battery3.w = battery3.spritesheet:getWidth() 
    battery3.room = "levelOne"

    function battery3:draw()
        if checkInventory(inventory, "battery3") == false then
            if Gamestate.current() == runLevelOne or Gamestate.current() == runGame then
        if battery3.room == room then
        love.graphics.draw(battery3.spritesheet,battery3.x,battery3.y)
        end
    end
    end
    end

    function battery3.load()
        battery3.x = data.battery3.x
        battery3.y = data.battery3.y
        battery3.room = data.battery3.room
    end