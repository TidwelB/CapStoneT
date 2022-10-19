Gamestate = require 'libraries.gamestate'
anim8 = require 'libraries/anim8'

-- makes stretch not blurry
love.graphics.setDefaultFilter("nearest", "nearest")

enemy = {}
enemy.width = 5
enemy.height = 5
enemy.speed = 200
enemy.friction = 7.5
enemy.spriteSheet = love.graphics.newImage('sprites/eyeball.png')
enemy.grid = anim8.newGrid(32, 32, enemy.spriteSheet:getWidth(), enemy.spriteSheet:getHeight())

enemy.animations = {}
enemy.animations.right = anim8.newAnimation(enemy.grid('1-4', 3), 0.25)
enemy.anim = enemy.animations.right


function enemy.spawn(x,y)
    table.insert(enemy, {x = x, y=y, xvel=0,yvel=0, health = 2, width = enemy.width, height = enemy.height})
end

function enemy.load()
    enemy.collider = world:newBSGRectangleCollider(400, 200, 65, 100, 14)
    enemy.collider:setFixedRotation(true)
    enemy.colX = 0
    enemy.colY = 0
    enemy.timer = 0
    enemy.colxvel = 0
    enemy.colyvel = 0

end


function enemy.draw()
    
        love.graphics.setColor(255,255,255)
        love.graphics.rectangle('fill',enemy.colX,enemy.colY,enemy.width,enemy.height)
        enemy.anim:draw(enemy.spriteSheet, enemy.colX,enemy.colY, nil, 6, nil, 8, 8)
end

function enemy.physics(dt)
    for i,v in ipairs(enemy) do
        v.x = v.x +v.xvel *dt
        v.y = v.y + v.yvel *dt
        v.xvel = v.xvel * (1-math.min(dt*enemy.friction,1))
        v.yvel = v.yvel * (1-math.min(dt*enemy.friction,1))
    end
end

function enemy.AI(dt)
    for i,v in ipairs(enemy) do
        if player.x + player.spriteSheet:getWidth() / 2 < v.x + v.width / 2 then
            if v.xvel > -enemy.speed then
                v.xvel = v.xvel - enemy.speed*dt
            end
        end

        if player.x + player.spriteSheet:getWidth() / 2 > v.x + v.width / 2 then
            if v.xvel < enemy.speed then
                v.xvel = v.xvel + enemy.speed*dt
            end
        end
        if player.y + player.spriteSheet:getHeight() / 2 < v.y + v.height / 2 then
            if v.yvel > - enemy.speed then
                v.yvel = v.yvel - enemy.speed *dt
            end
        end
        if player.y + player.spriteSheet:getHeight() / 2 > v.y + v.height / 2 then
            if v.yvel < enemy.speed then
                v.yvel = v.yvel + enemy.speed*dt
            end
        end
    end
    
end

function enemy.colAI(dt)
    --enemy.colxvel = 0
    --enemy.colyvel = 0
    enemy.timer = enemy.timer +1
    enemy.distance = ((player.x - enemy.collider:getX())^2 + (player.y - enemy.collider:getY())^2)^(1/2)
    enemy.xdist = ((player.x - enemy.collider:getX())^2)^(1/2)
    enemy.ydist = ((player.y - enemy.collider:getY())^2)^(1/2)

        if enemy.distance > 150 then
            if player.x > enemy.collider:getX() then
                enemy.colxvel = enemy.speed
                enemy.anim = enemy.animations.right
            end
            if player.x < enemy.collider:getX() then
                enemy.colxvel = -enemy.speed
                enemy.anim = enemy.animations.right
            end
            if player.y > enemy.collider:getY() + 20 then
                enemy.colyvel = enemy.speed
                enemy.anim = enemy.animations.right
            end
            if player.y < enemy.collider:getY() -20 then
                enemy.colyvel = -enemy.speed
                enemy.anim = enemy.animations.right
            end
        
        else
            if (enemy.timer%5 == 0) then
            enemy.colxvel = math.random(-50,50)
            enemy.colyvel = math.random(-50,50)

            enemy.collision()
            end
        end



        
        enemy.colX = enemy.colX + enemy.colxvel *dt
        enemy.colY = enemy.colY + enemy.colyvel *dt
        enemy.colxvel = enemy.colxvel * (1-math.min(dt*enemy.friction,1))
        enemy.colyvel = enemy.colyvel * (1-math.min(dt*enemy.friction,1))

        

        enemy.collider:setLinearVelocity(enemy.colxvel, enemy.colyvel)
end

function enemy.collision()
    if enemy.xdist < 68 then
        if enemy.ydist < 100 then
        enemy.colxvel = player.xvel
        end
    end
    if enemy.ydist < 101 then
        if enemy.xdist < 35 then
        enemy.colyvel = player.yvel
        end
    end
end

--PARENT
function DRAW_ENEMY()
    --enemy.draw()
end

function UPDATE_ENEMY(dt)
    enemy.colAI(dt)
    enemy.physics(dt)
    enemy.AI(dt)
end