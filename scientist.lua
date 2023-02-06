anim8 = require 'libraries/anim8'
Gamestate = require 'libraries.gamestate'

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

scientist.animations = {}
    scientist.animations.down = anim8.newAnimation( scientist.grid('1-4', 1), 0.25 )
    scientist.animations.up = anim8.newAnimation( scientist.grid('1-4', 2), 0.25 )
    scientist.animations.left = anim8.newAnimation( scientist.grid('1-4', 3), 0.25 )
    scientist.animations.right = anim8.newAnimation( scientist.grid('1-4', 4), 0.25 )    
    scientist.anim = scientist.animations.right

--function scientist.load()
    --scientist.collider = world:newBSGRectangleCollider(scientist.x, scientist.y, 55, 80, 14)
    --scientist.collider:setType('Static')
    --scientist.collider:setFixedRotation(true)
--end

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
    for i=0, x do 
    scientist.xvel = scientist.xvel - scientist.speed
    scientist.anim = scientist.animations.left
    end
    scientist.xvel = 0
    scientist.collider:setLinearVelocity(scientist.xvel, scientist.yvel)
end

function scientist.moveup()

    scientist.yvel = scientist.yvel - scientist.speed
    scientist.anim = scientist.animations.up
    scientist.collider:setLinearVelocity(scientist.xvel, scientist.yvel)
    scientist.stop()
end
function scientist.stop()

    scientist.yvel = 0
    scientist.xvel = 0
    scientist.anim:gotoFrame(3)
    scientist.collider:setLinearVelocity(scientist.xvel, scientist.yvel)

end

function scientist:update(dt)
    scientist.physics(dt)
    scientist.colliderMatching(dt)
end

function scientist.physics(dt)
    scientist.x = scientist.x + scientist.xvel * dt
    scientist.y = scientist.y + scientist.yvel * dt
    scientist.xvel = scientist.xvel * (1 - math.min(dt * 5, 1))
    scientist.yvel = scientist.yvel * (1 - math.min(dt * 5, 1))
end
