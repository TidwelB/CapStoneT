player = {}
anim8 = require 'libraries/anim8'
player.paused = 0




heartbeat = {}
    heartbeat.spritesheet = love.graphics.newImage('sprites/yellowhealth.png')
    heartbeat.grid = anim8.newGrid (64, 32, heartbeat.spritesheet:getWidth(), heartbeat.spritesheet:getHeight())
    heartbeat.animations = anim8.newAnimation( heartbeat.grid('1-84', 1),0.02)
    heartbeat.anim = heartbeat.animations


function player.load()

        player.collider = world:newBSGRectangleCollider(400, 250, 65, 100, 14)
        player.collider:setFixedRotation(true)
        player.x = 0
        player.y = 0
        player.xvel = 0
        player.yvel = 0
        player.friction = 5
        player.speed = 250
        player.stamina = 2000
        player.spriteSheet = love.graphics.newImage('sprites/guard_yellow_spritesheet.png')
        player.grid = anim8.newGrid( 16, 16, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

        player.animations = {}
        player.animations['down'] = anim8.newAnimation( player.grid('1-4', 1), 0.25 )
        player.animations.left = anim8.newAnimation( player.grid('1-4', 3), 0.25 )
        player.animations.right = anim8.newAnimation( player.grid('1-4', 4), 0.25 )
        player.animations.up = anim8.newAnimation( player.grid('1-4', 2), 0.25 )
        player.anim = player.animations.left

end

function player:update(dt)
        -- player.pause(dt)
        player.control(dt)
        player.physics(dt)
        player.colliderMatching(dt)
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
       if love.keyboard.isDown("escape") then
            Gamestate.push(menu)
       end

       if love.keyboard.isDown("p") then
            love.timer.sleep(.5)
            Gamestate.push(pause)
    end
    
       -- Freezes the frame on the idle sprite in that direction
       if (isMoving == false) then
            player.anim:gotoFrame(3)
       end
end

function player.physics(dt)
	player.x = player.x + player.xvel * dt
	player.y = player.y + player.yvel * dt
	player.xvel = player.xvel * (1 - math.min(dt*player.friction, 1))
	player.yvel = player.yvel * (1 - math.min(dt*player.friction, 1))
end

function player.draw()
    heartbeat.anim:draw(heartbeat.spritesheet,30, 30, nil,3, nil,  9,9)
end

function DRAW_HUD()
    player.draw()
end
