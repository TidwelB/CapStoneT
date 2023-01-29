
player = {}
inventory = {}
local testing = require("testing")
local tests = require('tests')

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

function player.load()
        player.collider = world:newBSGRectangleCollider(400, 250, 65, 100, 14)
        player.collider:setCollisionClass('Solid')
        player.collider:setFixedRotation(true)
end

function player:update(dt)
        player.keytimer = player.keytimer +1
        -- player.pause(dt)
        player.control(dt)
        player.physics(dt)
        player.colliderMatching(dt)
        transition.Transitioner(self)
        if (player.keytimer%1000 == 0) then
            --os.execute("clear")
            testing.run()
        end
end

function player.colliderMatching(dt)
        player.x = player.collider:getX()
        player.y = player.collider:getY()
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

    if love.keyboard.isDown("f")  then
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

    if love.keyboard.isDown("e") and checkInventory(inventory, "item1") == false and player.x == item1.x and player.y == item1.y then
        table.insert(inventory,"item1")
        --insert image of item into the inventory spot in the hud
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
    love.graphics.rectangle("line", 200, 15, 64, 64)
   -- love.graphics.print(player.x, 200, 15)
   -- love.graphics.print(player.y, 280, 60)
    love.graphics.rectangle("line", 280, 15, 64, 64)
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