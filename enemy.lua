Gamestate = require 'libraries.gamestate'


enemy = {}
enemy.width = 5
enemy.height = 5
enemy.speed = 1500
enemy.friction = 7.5


function enemy.spawn(x,y)
    table.insert(enemy, {x = x, y=y, xvel=0,yvel=0, health = 2, width = enemy.width, height = enemy.height})
end

function enemy.draw()
    for i,v in ipairs(enemy) do
        love.graphics.setColor(255,255,255)
        love.graphics.rectangle('fill',v.x,v.y,enemy.width,enemy.height)
    end
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

--PARENT
function DRAW_ENEMY()
    enemy.draw()
end

function UPDATE_ENEMY(dt)
    enemy.physics(dt)
    enemy.AI(dt)
end