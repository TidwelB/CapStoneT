
player = {}
inventory = {}
local testing = require("testing.testing")
local tests = require('testing.tests')

anim8 = require 'libraries/anim8'

transitionModule = require('util/transition')

player.paused = 0
player.spriteSheet = love.graphics.newImage('sprites/guard_yellow_spritesheet.png')
player.grid = anim8.newGrid( 16, 16, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
player.x = 0
player.y = 0
player.xvel = 0
player.yvel = 0
player.friction = 5
player.speed = 250
player.stamina = 2000
player.max_health = 100
player.health = 100
player.keytimer = 0

--this is for the green health sprite
heartbeat = {}
    heartbeat.spritesheet = love.graphics.newImage('sprites/greenheath2.png')
    heartbeat.grid = anim8.newGrid (64, 32, heartbeat.spritesheet:getWidth(), heartbeat.spritesheet:getHeight())
    heartbeat.animations = anim8.newAnimation( heartbeat.grid('1-107', 1),0.025)
    heartbeat.anim = heartbeat.animations


yellowheartbeat = {}
    yellowheartbeat.spritesheet = love.graphics.newImage('sprites/yellowhealth.png')
    yellowheartbeat.grid = anim8.newGrid (64, 32, yellowheartbeat.spritesheet:getWidth(), yellowheartbeat.spritesheet:getHeight())
    yellowheartbeat.animations = anim8.newAnimation( yellowheartbeat.grid('1-84', 1),0.020)
    yellowheartbeat.anim = yellowheartbeat.animations
    
--this is for the red health sprite
redheartbeat = {}
    redheartbeat.spritesheet = love.graphics.newImage('sprites/redhealth.png')
    redheartbeat.grid = anim8.newGrid (64, 32, redheartbeat.spritesheet:getWidth(), redheartbeat.spritesheet:getHeight())
    redheartbeat.animations = anim8.newAnimation( redheartbeat.grid('1-109', 1),0.015)
    redheartbeat.anim = redheartbeat.animations

player.animations = {}
    player.animations['down'] = anim8.newAnimation( player.grid('1-4', 1), 0.25 )
    player.animations.left = anim8.newAnimation( player.grid('1-4', 3), 0.25 )
    player.animations.right = anim8.newAnimation( player.grid('1-4', 4), 0.25 )
    player.animations.up = anim8.newAnimation( player.grid('1-4', 2), 0.25 )
    player.anim = player.animations.left

function player.load(x,y)
if x == nil then
    x = 450
    y = 300
end
        player.collider = world:newBSGRectangleCollider(x, y, 55, 80, 14)
        player.collider:setCollisionClass('Solid')
        player.collider:setFixedRotation(true)
end

function player:update(dt)
    if player.keytimer < 500 then
        player.keytimer = player.keytimer +1
    end
    if player.keytimer >= 500 then
        player.keytimer = 0
    end
        -- player.pause(dt)
        player.control(dt)
        player.physics(dt)
        player.colliderMatching(dt)
        transition.Transitioner(self)
        if (player.keytimer%1000 == 0) then
            --os.execute("clear")
            --testing.run()
        end
end

function player.colliderMatching(dt)
        player.x = player.collider:getX() - 10
        player.y = player.collider:getY() -13
end

function player.control(dt)
        local isMoving = false
        player.xvel = 0
        player.yvel = 0
        player.speed = 250

        if player.stamina < 2000 then
        player.stamina = player.stamina +2
        end

        if love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift') then
            if player.stamina > 0 then
                player.speed = 500
                player.anim:update(.005)
            end
            if player.stamina > -9 then
                player.stamina = player.stamina -5
            end          
        end
        -- Player Movement
        
        




       if love.keyboard.isDown("d") then
           player.xvel = player.speed
           player.anim = player.animations.right
           isMoving = true
       end
       if love.keyboard.isDown("a") then
           player.xvel = player.speed * -1
           player.anim = player.animations.left
           isMoving = true
       end
       if love.keyboard.isDown("s") then
           player.yvel = player.speed
           player.anim = player.animations['down']
           isMoving = true
       end
       if love.keyboard.isDown("w") then
           player.yvel = player.speed * -1
           player.anim = player.animations.up
           isMoving = true
       end


       if shaders.flashlight == true then
       local width, height = love.window.getMode()
       local mousex, mousey = love.mouse.getPosition()
       if mousex < width/2.5 then 
           player.anim = player.animations.left
       end
       if mousex > (width -(.4*width)) then
           player.anim = player.animations.right
       end
       if mousey < height/2.5 then
           player.anim = player.animations.up
       end
       if mousey > (height -(.4*height)) then
           player.anim = player.animations.down
       end
    end

       -- Sets the players hitbox to move with where our 
       -- player is currently moving
       player.collider:setLinearVelocity(player.xvel, player.yvel)


       -- switches game back into the main menu
    --    if love.keyboard.isDown("escape") then
    --     --need to set the size of screen to match the main screen or shrink the screen size
    --         love.window.setMode(800, 600)
    --         Gamestate.push(menu)
    --    end


       if love.keyboard.isDown("escape") then
            love.timer.sleep(.15)
            --Sounds.music:pause()
            Gamestate.push(pause)
    end

--and checkInventory(inventory, "flashlight") == true

    if love.keyboard.isDown("f") and checkInventory(inventory, "flashlight")  then
    if (player.keytimer > 150) then
        if (shaders.flashlight == false) then
            shaders.flashlight = true
            player.keytimer = 0
        else
            shaders.flashlight = false
            player.keytimer = 0
        end
    end
end


function distanceBetweenSprites(x1, y1, w1, h1, x2, y2, w2, h2)
    local center1_x = x1 + w1/2
    local center1_y = y1 + h1/2
    local center2_x = x2 + w2/2
    local center2_y = y2 + h2/2
  
    local x_distance = center1_x - center2_x
    local y_distance = center1_y - center2_y
    local distance = math.sqrt(x_distance^2 + y_distance^2)
  
    return distance
  end
  

if love.keyboard.isDown("e") and (checkInventory(inventory, "gengar") == false or checkInventory(inventory,"flashlight") == false) and inventory[2] == nil then
    if distanceBetweenSprites(player.x, player.y, 55, 80, gengar.x+30, gengar.y+50, gengar.w, gengar.h) < 100 and checkInventory(inventory,"gengar") == false and inventory[2] == nil then
       --print("added Genga to inventory") 
        table.insert(inventory,"gengar")
       --print(distanceBetweenSprites(player.x, player.y, 65, 100, gengar.x+30, gengar.y+50, gengar.w, gengar.h)) 
    end
    if distanceBetweenSprites(player.x, player.y, 55, 80, flashlight.x, flashlight.y, flashlight.w*flashlight.scale,flashlight.h*flashlight.scale ) <100 and checkInventory(inventory,"flashlight") == false and inventory[2] == nil then
        --print("added flashlight to inventory")
        table.insert(inventory,"flashlight")
    end
    if distanceBetweenSprites(player.x, player.y, 55, 80, rock.x, rock.y, rock.w, rock.h ) <100 and checkInventory(inventory,"rock") == false  and player.keytimer > 150 and inventory[2] == nil then
        --print("added rock to inventory")
        table.insert(inventory,"rock")
        player.keytimer = 0
    end

    
end
--print(player.keytimer)
local mouseX, mouseY = love.mouse:getPosition()
    if mouseX >= 200 and mouseX <= 264 and mouseY >= 15 and mouseY <= 79 and love.mouse.isDown(1) and player.keytimer > 150 then

    DropItem(1)
    elseif mouseX >= 280 and mouseX <= 344 and mouseY >= 15 and mouseY <= 79 and love.mouse.isDown(1) and player.keytimer > 150 then
    DropItem(2)
    --end
end

function DropItem(param)
    local item = inventory[param]
    table.remove(inventory, param)
    local x,y
    if player.anim == player.animations.right then
        x = player.collider:getX() + 60
        y = player.collider:getY()
    end
    if player.anim == player.animations.left then 
         x = player.collider:getX() -10
         y = player.collider:getY()
    end
    if player.anim == player.animations.up then 
         x = player.collider:getX()
         y = player.collider:getY() -60
    end
    if player.anim == player.animations.down then
         x = player.collider:getX()
         y = player.collider:getY() +60
    end
    if item == "rock" then
        rock.collider:setPosition(x,y)
    end
    if item == "flashlight" then
        flashlight.x = x
        flashlight.y = y
    end
    if item == "gengar" then
        gengar.x = x
        gengar.y = y
        gengar.room = room
    end
    player.keytimer = 0

end

       -- Freezes the frame on the idle sprite in that direction
       if (isMoving == false) then
            player.anim:gotoFrame(3)
       end

       if love.keyboard.isDown("l") then
        player.health = player.health - .1
       end

       if love.keyboard.isDown("k") then
        player.health = player.health + .1
       end
       
       if player.health <= 0 then
        Gamestate.switch(lose)
        player.health = 100
       end
end

function player.physics(dt)
	player.x = player.x + player.xvel * dt
	player.y = player.y + player.yvel * dt
	player.xvel = player.xvel * (1 - math.min(dt*player.friction, 1))
	player.yvel = player.yvel * (1 - math.min(dt*player.friction, 1))
end

function player.draw()
    -- Health Bar
    -- Green above 50%
    if (player.health > (player.max_health / 2)) then
        heartbeat.anim:draw(heartbeat.spritesheet,30, 30, nil,3, nil,  9,9) 
    -- Yellow between 50% and 25%
    elseif ( player.health <= (player.max_health / 2) and player.health > (player.max_health / 4)) then
        yellowheartbeat.anim:draw(yellowheartbeat.spritesheet,30, 30, nil,3, nil,  9,9)
    -- Red under 25%
    elseif (player.health <= (player.max_health / 4)) then
        redheartbeat.anim:draw(redheartbeat.spritesheet,30, 30, nil,3, nil,  9,9) 
    end

    -- Blue coloring for stamina bar
    love.graphics.setColor(0,0,255)
    -- Stamina Bar
    love.graphics.rectangle("fill", 5, 90, math.floor(190 * (player.stamina/2000)), 25)
    love.graphics.reset()
    -- Text that sits on stamina bar
    love.graphics.print("Sprint", 5, 90, nil, 1)

    -- Inventory Boxes
    local position = findItem("flashlight")
    local position2 = findItem("gengar")
    local position3 = findItem("rock")
    if love.keyboard.isDown("tab") then

        love.graphics.rectangle("line", 200, 15, 64, 64)
        love.graphics.rectangle("line", 280, 15, 64, 64)
        if position3 == 1 then
            love.graphics.draw(rock.spritesheet,207.5,19,0,1.5,1.5)
        end
        if position3 == 2 then
            love.graphics.draw(rock.spritesheet,287,18,0,1.5,1.5)
        end
        if position == 1 then
            love.graphics.draw(flashlight.spritesheet,209,20,0,flashlight.scale,flashlight.scale)
        end
        if position == 2 then
            love.graphics.draw(flashlight.spritesheet,287,21,0,flashlight.scale,flashlight.scale)
        end
        if position2 == 1 then
            love.graphics.draw(gengar.spritesheet,207.5,19,0,.5,.5)
        end
        if position2 == 2 then
            love.graphics.draw(gengar.spritesheet,287,18,0,.5,.5)
        end
    
    end
end

function DRAW_HUD()
    player.draw()
end
 
function checkInventory(inventory, item)
    for _, value in pairs(inventory) do
        if value == item then
            return true
        end
    end
    return false
end

function findItem(item)
    for i, v in ipairs(inventory) do
      if v == item then
        return i
      end
    end
    return -1
  end