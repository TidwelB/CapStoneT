anim8 = require 'libraries/anim8'
Gamestate = require 'libraries.gamestate'
Moan = require 'libraries/Moan/Moan'
scientist = {}


scientist.x = 500
scientist.y = 500
scientist.speed = 200
scientist.xvel = 0
scientist.yvel = 0
scientist.timer = 0
scientist.spriteSheet = love.graphics.newImage('sprites/guard_white_spritesheet.png')
scientist.grid = anim8.newGrid(16, 16, scientist.spriteSheet:getWidth(), scientist.spriteSheet:getHeight())
scientist.w = scientist.spriteSheet:getWidth()
scientist.h = scientist.spriteSheet:getHeight()
scientist.icon = love.graphics.newImage('sprites/scientist.png')

scientist.animations = {}
    scientist.animations.down = anim8.newAnimation( scientist.grid('1-4', 1), 0.25 )
    scientist.animations.up = anim8.newAnimation( scientist.grid('1-4', 2), 0.25 )
    scientist.animations.left = anim8.newAnimation( scientist.grid('1-4', 3), 0.25 )
    scientist.animations.right = anim8.newAnimation( scientist.grid('1-4', 4), 0.25 )    
    scientist.anim = anim8.newAnimation( scientist.grid(1, 4), 1)

local function getPos()
    return scientist.x, scientist.y
end

local function getWidth()
    return scientist.w
end

local function getHeight()
    return scientist.h
end

function scientist.draw()
        love.graphics.setColor(255,255,255)
        love.graphics.rectangle('fill',scientist.x,scientist.y,scientist.spriteSheet:getWidth(),scientist.dspriteSheet:getHeight())
        scientist.anim:draw(scientist.spriteSheet, scientist.x, scientist.y, nil, 6, nil, 8, 8)
end

function scientist.colliderMatching(dt)
    scientist.x = scientist.collider:getX() - 10
    scientist.y = scientist.collider:getY() - 13
end

function scientist.spawn(x,y)
    scientist.x = x
    scientist.y = y
    scientist.collider = world:newBSGRectangleCollider(scientist.x, scientist.y, 55, 80, 14)
    scientist.collider:setType('kinematic')
    scientist.collider:setFixedRotation(true)

    table.insert(scientist, {scientist.x == x, scientist.y == y, 0, 0, 1, scientist.w, scientist.h})
end

function scientist.moveleft(x)
    scientist.xvel = scientist.speed
    local update_position = function (dt)
        elapsed_time = 0
        elapsed_time = elapsed_time + dt
        if elapsed_time >= x then
            scientist.xvel = 0
            scientist.collider:setLinearVelocity(0, 0)
            game.update:removeFunction(update_position)
        else
            scientist.collider:setLinearVelocity(scientist.xvel, scientist.yvel)
        end
    end
end

function scientist.move(dt, direction)
    if direction == "left" then
        scientist.xvel = -scientist.speed * dt
        scientist.anim = scientist.animations.left
    elseif direction == "right" then
        scientist.xvel = scientist.speed * dt
        scientist.anim = scientist.animations.right
    elseif direction == "up" then
        scientist.yvel = -scientist.speed * dt
        scientist.anim = scientist.animations.up
    elseif direction == "down" then
        scientist.yvel = scientist.speed * dt
        scientist.anim = scientist.animations.down
    end
    scientist.x = scientist.x + scientist.xvel
    scientist.y = scientist.y + scientist.yvel
    scientist.collider:setLinearVelocity(scientist.xvel, scientist.yvel)
end

function scientist.stop()
    scientist.yvel = 0
    scientist.xvel = 0
    scientist.collider:setLinearVelocity(0,0)
    scientist.anim:gotoFrame(3)
end

function scientist:update(dt)
    scientist.physics(dt)
    scientist.colliderMatching(dt)
    scientist.response(dt)
    Moan.update(dt)
end

function scientist.physics(dt)
    scientist.x = scientist.x + scientist.xvel * dt
    scientist.y = scientist.y + scientist.yvel * dt
    scientist.xvel = scientist.xvel * (1 - math.min(dt * 5, 1))
    scientist.yvel = scientist.yvel * (1 - math.min(dt * 5, 1))
end

-- chat
function scientist.response(dt)
    -- if player presses "e" close enough to scientist then he talks
    -- press space to loop dialog
    if love.keyboard.isDown("e") and distanceBetweenSprites(player.x, player.y, 55, 80, scientist.x, scientist.y, scientist.w,scientist.h) < 80 then
        Moan.speak("Scientist", { "Hello, to escape the facility you will need to collect 3 seperate items located in 3 different rooms." , "Each room will have a seperate puzzle. But be careful there are escaped SCPs that if you get too close they will kill you", "A hint for the first puzzle is check under the boxes you are looking for three batteries to unlock the ball.", "As for a hint on another room, check all the computers and a guide will be provided", "Last hint find the blue and green screens they will provide you the key"}, {image = scientist.icon })

        if checkInventory(inventory, "rock") == true then
            Moan.speak("Scientist", { "you rock" }, {image = scientist.icon })
        end
        if checkInventory(inventory, "gengar") == true then
            Moan.speak("Scientist", { "You got the gengar" }, {image = scientist.icon })
        end
                if checkInventory(inventory, "flashlight") == true then
            Moan.speak("Scientist", { "You got the flashlight" }, {image = scientist.icon })
        end
--        Moan.speak("Scientist", {"Should I stop talking?"}, {x=10, y=10, image=scientist.icon,
--                  onstart=function() camera:move(100, 20) end,
--                   options={
--                    {"Yes",  function() scientist.goodbye() end},
--                    {"No", function() end},
--                     }}
--                   )
    end

    -- if player leaves radius the chat disapears
    if distanceBetweenSprites(player.x, player.y, 55, 80, scientist.x, scientist.y, scientist.w, scientist.h) > 150 then
        Moan.clearMessages()
    end
end

function scientist.goodbye() 
        Moan.speak("\n", { "\n"})
end

function love.keypressed(key)
    Moan.keypressed(key)
end